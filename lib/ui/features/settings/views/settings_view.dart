import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../data/session_profile.dart';
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
    final profile = ref.watch(sessionProfileProvider);
    final isSignedIn = user != null || profile.isSignedIn;
    final isStaff =
        (user?.role == 'admin' || user?.role == 'reviewer') || profile.isStaff;
    final displayTitle = user != null
        ? (user.displayName.isEmpty ? user.email : user.displayName)
        : profile.label;
    final displayEmail = user?.email ?? profile.email ?? '';
    final roleLabel = profile.role != null
        ? profile.roleLabel
        : (user?.role == 'admin'
            ? 'Admin'
            : (user?.role == 'reviewer' ? 'Người rà soát' : 'Thành viên'));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          if (isSignedIn) ...[
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(displayTitle),
              subtitle: Text('$displayEmail · $roleLabel'),
            ),
            if (isStaff)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: const Text('Quản trị'),
                subtitle: const Text('Duyệt câu, thống kê, phân quyền'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/admin'),
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
