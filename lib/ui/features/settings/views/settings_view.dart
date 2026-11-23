import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_feedback.dart';
import '../../auth/view_models/auth_session.dart';
import '../view_models/settings_view_model.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsViewModelProvider);
    final notifier = ref.read(settingsViewModelProvider.notifier);
    final auth = ref.watch(authSessionProvider).asData?.value;
    final user = auth?.user;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              title: Text(user.displayName.isEmpty ? user.email : user.displayName),
              subtitle: Text(user.email),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: Text(l10n.logout),
              onTap: () async {
                await ref.read(authSessionProvider.notifier).logout();
                if (!context.mounted) return;
                showAppSnack(
                  context,
                  'Đã đăng xuất',
                  tone: AppFeedbackTone.success,
                );
                context.go('/login');
              },
            ),
            const Divider(),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.login_rounded),
              title: Text(l10n.login),
              onTap: () => context.go('/login'),
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_rounded),
              title: Text(l10n.register),
              onTap: () => context.go('/register'),
            ),
            const Divider(),
          ],
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
