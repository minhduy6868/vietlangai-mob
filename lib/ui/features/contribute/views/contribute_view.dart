import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

class ContributeView extends ConsumerStatefulWidget {
  const ContributeView({super.key});

  @override
  ConsumerState<ContributeView> createState() => _ContributeViewState();
}

class _ContributeViewState extends ConsumerState<ContributeView> {
  final _source = TextEditingController();
  final _target = TextEditingController();
  final _note = TextEditingController();
  String? _language;
  String _message = '';
  bool _saving = false;

  @override
  void dispose() {
    _source.dispose();
    _target.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final languages = ref.watch(languagesProvider);
    final saved = ref.watch(contributionsProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.contributeTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        languages.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text('$error'),
          data: (rows) {
            final ethnic = rows.where((row) => row.role == 'ethnic').toList();
            if (ethnic.isEmpty) return Text(l10n.emptyPeoples);
            _language ??= ethnic.first.code;
            return DropdownButtonFormField<String>(
              value: _language,
              items: [
                for (final row in ethnic)
                  DropdownMenuItem(
                    value: row.code,
                    child: Text(locale == 'vi' ? row.nameVi : row.nameEn),
                  ),
              ],
              onChanged: (value) => setState(() => _language = value),
            );
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _source,
          decoration: InputDecoration(labelText: l10n.sourceText, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _target,
          decoration: InputDecoration(labelText: l10n.targetText, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _note,
          decoration: InputDecoration(labelText: l10n.note, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _saving ? null : () => _save(l10n),
          child: Text(l10n.saveLocal),
        ),
        if (_message.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_message)),
        const SizedBox(height: 16),
        saved.when(
          loading: () => const SizedBox.shrink(),
          error: (error, _) => Text('$error'),
          data: (rows) => Column(
            children: [
              for (final row in rows)
                ListTile(
                  title: Text(row.sourceText),
                  subtitle: Text('${row.targetText}\n${row.status == 'pending' ? l10n.pending : row.status}'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _save(AppLocalizations l10n) async {
    final language = _language;
    if (language == null || _source.text.trim().isEmpty || _target.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final draft = Contribution(
      clientId: const Uuid().v4(),
      languageCode: language,
      sourceLang: language,
      targetLang: 'vi',
      sourceText: _source.text.trim(),
      targetText: _target.text.trim(),
      note: _note.text.trim(),
    );
    await ref.read(localStoreProvider).saveContribution(draft);
    final report = await ref.read(syncRunnerProvider)();
    ref.invalidate(contributionsProvider);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _message = report.online ? l10n.online : l10n.offlineSaved;
      _source.clear();
      _target.clear();
      _note.clear();
    });
  }
}
