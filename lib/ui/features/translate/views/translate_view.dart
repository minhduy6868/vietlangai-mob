import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/services/ocr_engine.dart';
import '../../../../data/wiring.dart';
import '../../../../domain/models/models.dart';
import '../../../../domain/recognize_text.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

class TranslateUiState {
  const TranslateUiState({this.loading = false, this.result, this.error});

  final bool loading;
  final TranslationResult? result;
  final String? error;

  TranslateUiState copyWith({
    bool? loading,
    TranslationResult? result,
    String? error,
    bool clearError = false,
  }) {
    return TranslateUiState(
      loading: loading ?? this.loading,
      result: result ?? this.result,
      error: clearError ? error : error ?? this.error,
    );
  }
}

class TranslateViewModel extends Notifier<TranslateUiState> {
  @override
  TranslateUiState build() => const TranslateUiState();

  Future<void> translate(String text, String source, String target) async {
    state = state.copyWith(loading: true, clearError: true);
    final api = ref.read(apiClientProvider);
    try {
      final result = await api.guard(
        api.translateText(text: text, sourceLang: source, targetLang: target),
      );
      state = state.copyWith(loading: false, result: result);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }
}

final translateViewModelProvider = NotifierProvider<TranslateViewModel, TranslateUiState>(
  TranslateViewModel.new,
);

class TranslateView extends ConsumerStatefulWidget {
  const TranslateView({super.key});

  @override
  ConsumerState<TranslateView> createState() => _TranslateViewState();
}

class _TranslateViewState extends ConsumerState<TranslateView> {
  final _text = TextEditingController();
  String? _source;
  String? _target;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languages = ref.watch(languagesProvider);
    final translation = ref.watch(translateViewModelProvider);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    return languages.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (rows) {
        if (rows.isEmpty) return Center(child: Text(l10n.emptyPeoples));
        _source ??= rows.first.code;
        _target ??= rows.firstWhere((row) => row.code == 'vi', orElse: () => rows.last).code;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _source,
              decoration: InputDecoration(labelText: l10n.sourceLanguage),
              items: _items(rows, locale),
              onChanged: (value) => setState(() => _source = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _target,
              decoration: InputDecoration(labelText: l10n.targetLanguage),
              items: _items(rows, locale),
              onChanged: (value) => setState(() => _target = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _text,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(labelText: l10n.enterText, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _readPhoto(l10n),
              icon: const Icon(Icons.document_scanner_outlined),
              label: Text(l10n.pickImage),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: translation.loading
                  ? null
                  : () => ref
                        .read(translateViewModelProvider.notifier)
                        .translate(_text.text, _source!, _target!),
              child: Text(translation.loading ? l10n.loading : l10n.translate),
            ),
            if (translation.error != null)
              Padding(padding: const EdgeInsets.only(top: 12), child: Text(translation.error!)),
            if (translation.result != null) ...[
              const SizedBox(height: 16),
              Text(l10n.result, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SelectableText(translation.result!.text),
              if (translation.result!.warnings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('${l10n.warnings}\n${translation.result!.warnings.join('\n')}'),
                ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _readPhoto(AppLocalizations l10n) async {
    final picked = await FilePicker.pickFiles(type: FileType.image, withData: false);
    final path = picked?.files.single.path;
    if (path == null) {
      _show(l10n.ocrUnavailable);
      return;
    }
    try {
      final page = await RecognizeTextUseCase(MlKitHolder.engine).call(path);
      _text.text = page.text;
    } on OcrEmptyException {
      _show(l10n.ocrEmpty);
    } on UnsupportedError {
      _show(l10n.ocrUnavailable);
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  List<DropdownMenuItem<String>> _items(List<Language> rows, String locale) {
    return [
      for (final row in rows)
        DropdownMenuItem(value: row.code, child: Text(locale == 'vi' ? row.nameVi : row.nameEn)),
    ];
  }
}

class MlKitHolder {
  static final OcrEngine engine = createOcrEngine();
}
