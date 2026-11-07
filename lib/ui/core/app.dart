import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/views/login_view.dart';
import '../features/contribute/views/contribute_view.dart';
import '../features/heritage/views/heritage_views.dart';
import '../features/learn/views/learn_views.dart';
import '../features/settings/view_models/settings_view_model.dart';
import '../features/settings/views/settings_view.dart';
import '../features/translate/views/translate_view.dart';
import 'app_shell.dart';
import 'app_theme.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/translate',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/translate', builder: (context, state) => const TranslateView())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/heritage',
                builder: (context, state) => const HeritageListView(),
                routes: [
                  GoRoute(
                    path: ':slug',
                    builder: (context, state) => HeritageDetailView(slug: state.pathParameters['slug']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/learn',
                builder: (context, state) => const LearnListView(),
                routes: [
                  GoRoute(
                    path: ':lessonId',
                    builder: (context, state) => QuizView(lessonId: state.pathParameters['lessonId']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/contribute', builder: (context, state) => const ContributeView())],
          ),
        ],
      ),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsView()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    ],
  );
});

class NgonSacVietApp extends ConsumerWidget {
  const NgonSacVietApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
