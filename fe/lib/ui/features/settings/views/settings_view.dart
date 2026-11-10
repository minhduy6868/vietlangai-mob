import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/settings_view_model.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsViewModelProvider);
    final notifier = ref.read(settingsViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(title: Text(l10n.theme)),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            title: Text(l10n.themeSystem),
            onChanged: (value) => notifier.setTheme(value!),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            title: Text(l10n.themeLight),
            onChanged: (value) => notifier.setTheme(value!),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            title: Text(l10n.themeDark),
            onChanged: (value) => notifier.setTheme(value!),
          ),
          const Divider(),
          ListTile(title: Text(l10n.uiLanguage)),
          RadioListTile<String>(
            value: 'vi',
            groupValue: settings.locale.languageCode,
            title: const Text('Tiếng Việt'),
            onChanged: (value) => notifier.setLocale(Locale(value!)),
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: settings.locale.languageCode,
            title: const Text('English'),
            onChanged: (value) => notifier.setLocale(Locale(value!)),
          ),
        ],
      ),
    );
  }
}
