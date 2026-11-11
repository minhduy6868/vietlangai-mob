import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../data/services/api_client.dart';
import '../../../../data/services/ocr_engine.dart';
import '../../../../data/wiring.dart';
import '../../../../domain/language_order.dart';
import '../../../../domain/models/models.dart';
import '../../../../domain/recognize_text.dart';
import '../../../app_providers.dart';
import '../../../core/app_feedback.dart';
import '../../settings/view_models/settings_view_model.dart';

class TranslateUiState {
  const TranslateUiState({
    this.loading = false,
    this.result,
    this.error,
    this.pronunciation,
    this.culturalNote,
  });

  final bool loading;
  final TranslationResult? result;
  final String? error;
  final String? pronunciation;
  final String? culturalNote;

  TranslateUiState copyWith({
    bool? loading,
    TranslationResult? result,
    String? error,
    String? pronunciation,
    String? culturalNote,
    bool clearError = false,
  }) {
    return TranslateUiState(
      loading: loading ?? this.loading,
      result: result ?? this.result,
      error: clearError ? error : error ?? this.error,
      pronunciation: pronunciation ?? this.pronunciation,
      culturalNote: culturalNote ?? this.culturalNote,
    );
  }
}

class TranslateViewModel extends Notifier<TranslateUiState> {
  @override
  TranslateUiState build() => const TranslateUiState();

  Future<void> translate(String text, String source, String target) async {
    if (text.trim().isEmpty) return;
    state = state.copyWith(loading: true, clearError: true, pronunciation: null, culturalNote: null);
    final api = ref.read(apiClientProvider);
    try {
      final result = await api.guard(
        api.translateText(text: text, sourceLang: source, targetLang: target),
      );
      state = state.copyWith(loading: false, result: result);
    } on ApiException catch (error) {
      state = state.copyWith(loading: false, error: error.message);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }
}

final translateViewModelProvider =
    NotifierProvider<TranslateViewModel, TranslateUiState>(
  TranslateViewModel.new,
);

class TranslateView extends ConsumerStatefulWidget {
  const TranslateView({super.key});

  @override
  ConsumerState<TranslateView> createState() => _TranslateViewState();
}

class _TranslateViewState extends ConsumerState<TranslateView> {
  final _textController = TextEditingController();
  String? _sourceCode;
  String? _targetCode;
  int _selectedInputTab = 0; // 0: Bàn phím, 1: Giọng nói, 2: Quét ảnh

  final List<Map<String, String>> _recentTranslations = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceCode;
      _sourceCode = _targetCode;
      _targetCode = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final languagesAsync = ref.watch(languagesProvider);
    final translation = ref.watch(translateViewModelProvider);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;

    return languagesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (rows) {
        if (rows.isEmpty) return Center(child: Text(l10n.emptyPeoples));

        _sourceCode ??= firstEthnic(rows)?.code ?? rows.first.code;
        _targetCode ??= vietnamese(rows)?.code ?? 'vi';

        final sourceLang = rows.firstWhere((r) => r.code == _sourceCode, orElse: () => rows.first);
        final targetLang = rows.firstWhere((r) => r.code == _targetCode, orElse: () => rows.last);

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 1. Language Switcher Bar (Figma Style)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF2E2E32) : const Color(0xFFEBE5DF),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildLanguageSelectorPill(
                      context,
                      label: displayName(sourceLang),
                      onTap: () => _showLanguageModal(rows, isSource: true, locale: locale),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đổi ngôn ngữ',
                    onPressed: _swapLanguages,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.swap_horiz_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildLanguageSelectorPill(
                      context,
                      label: displayName(targetLang),
                      onTap: () => _showLanguageModal(rows, isSource: false, locale: locale),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. Input Mode Chips: Bàn phím / Giọng nói / Quét ảnh
            Row(
              children: [
                _buildModeChip(
                  index: 0,
                  icon: Icons.keyboard_outlined,
                  label: 'Bàn phím',
                  onTap: () => setState(() => _selectedInputTab = 0),
                ),
                const SizedBox(width: 8),
                _buildModeChip(
                  index: 1,
                  icon: Icons.mic_none_rounded,
                  label: 'Giọng nói',
                  onTap: () {
                    setState(() => _selectedInputTab = 1);
                    _simulateVoiceInput(l10n);
                  },
                ),
                const SizedBox(width: 8),
                _buildModeChip(
                  index: 2,
                  icon: Icons.document_scanner_outlined,
                  label: 'Quét ảnh',
                  onTap: () {
                    setState(() => _selectedInputTab = 2);
                    _readPhoto(l10n);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 3. Source Text Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _textController,
                      minLines: 3,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                      decoration: InputDecoration(
                        hintText: l10n.enterText,
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Phát âm thanh',
                          onPressed: () => _show('Phát âm câu gốc: ${_textController.text}'),
                          icon: Icon(
                            Icons.volume_up_outlined,
                            size: 20,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        if (_textController.text.isNotEmpty)
                          IconButton(
                            tooltip: 'Xóa',
                            onPressed: () => setState(() => _textController.clear()),
                            icon: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: translation.loading
                              ? null
                              : () => ref
                                  .read(translateViewModelProvider.notifier)
                                  .translate(_textController.text, _sourceCode!, _targetCode!),
                          icon: translation.loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.arrow_forward_rounded, size: 18),
                          label: Text(translation.loading ? l10n.loading : l10n.translate),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 4. Translation Result Card (Figma Style)
            if (translation.error != null) ...[
              Card(
                child: ListTile(
                  leading: Icon(Icons.error_outline_rounded, color: theme.colorScheme.error),
                  title: Text(
                    _friendlyError(l10n, translation.error!),
                    style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showAppAlert(
                    context,
                    title: l10n.translate,
                    message: _friendlyError(l10n, translation.error!),
                    tone: AppFeedbackTone.error,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (translation.result != null) ...[
              _buildResultCard(
                context,
                translation: translation,
                resultText: translation.result!.text,
                pronunciation: translation.pronunciation,
                culturalNote: translation.culturalNote,
              ),
              const SizedBox(height: 20),
            ],

            // 5. Recent Translations Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lịch sử tra cứu',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                TextButton(
                  onPressed: () => _show('Đã làm mới lịch sử'),
                  child: const Text('Xem tất cả', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            for (final item in _recentTranslations)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark ? const Color(0xFF2A2A2E) : const Color(0xFFEFEBE4),
                  ),
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  title: Text(
                    item['source']!,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text(
                    '${item['target']} (${item['from']} → ${item['to']})',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  trailing: Icon(
                    Icons.north_west_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  onTap: () {
                    _textController.text = item['source']!;
                    ref.read(translateViewModelProvider.notifier).translate(
                          item['source']!,
                          _sourceCode!,
                          _targetCode!,
                        );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageSelectorPill(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildModeChip({
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedInputTab == index;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.12)
                : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : (isDark ? const Color(0xFF2E2E32) : const Color(0xFFEBE5DF)),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _friendlyError(AppLocalizations l10n, String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('model_not_ready') ||
        lower.contains('chưa có mô hình') ||
        lower.contains('no reviewed translator')) {
      return l10n.modelNotReady;
    }
    return raw;
  }

  Widget _buildResultCard(
    BuildContext context, {
    required TranslateUiState translation,
    required String resultText,
    String? pronunciation,
    String? culturalNote,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final warnings = translation.result?.warnings ?? const <String>[];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF221715) : const Color(0xFFFFF7F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.4 : 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'BẢN DỊCH',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Sao chép',
                icon: const Icon(Icons.copy_rounded, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: resultText));
                  _show('Đã sao chép kết quả');
                },
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Chia sẻ',
                icon: const Icon(Icons.share_outlined, size: 18),
                onPressed: () => _show('Chia sẻ câu dịch'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            resultText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isDark ? const Color(0xFFFFDAD6) : const Color(0xFF410002),
            ),
          ),
          if (pronunciation != null && pronunciation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Phiên âm: $pronunciation',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _show('Phát âm: $pronunciation'),
                  child: Icon(
                    Icons.volume_up_rounded,
                    size: 17,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
          if (culturalNote != null && culturalNote.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B1B1E) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? const Color(0xFF333338) : const Color(0xFFEBE5DF),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      culturalNote,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (warnings.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              warnings.join('\n'),
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLanguageModal(List<Language> rows, {required bool isSource, required String locale}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    isSource ? 'Chọn ngôn ngữ nguồn' : 'Chọn ngôn ngữ đích',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final item = rows[index];
                      final isSelected = isSource ? item.code == _sourceCode : item.code == _targetCode;
                      return ListTile(
                        title: Text(
                          item.role == 'auxiliary' || item.code == 'en'
                              ? '${displayName(item)} · ${AppLocalizations.of(context).viaVietnamese}'
                              : displayName(item),
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(item.family),
                        trailing: isSelected
                            ? Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary)
                            : null,
                        onTap: () {
                          setState(() {
                            if (isSource) {
                              _sourceCode = item.code;
                            } else {
                              _targetCode = item.code;
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _simulateVoiceInput(AppLocalizations l10n) {
    _show('Nhận giọng nói trên máy chưa sẵn sàng. Hãy gõ câu hoặc dùng API giọng nói từ bản điện thoại.');
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
      _textController.text = page.text;
    } on OcrEmptyException {
      _show(l10n.ocrEmpty);
    } on UnsupportedError {
      _show(l10n.ocrUnavailable);
    }
  }

  void _show(String message, {AppFeedbackTone tone = AppFeedbackTone.info}) {
    showAppSnack(context, message, tone: tone);
  }
}

class MlKitHolder {
  static final OcrEngine engine = createOcrEngine();
}
