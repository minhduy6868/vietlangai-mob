import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../features/admin/views/admin_view.dart';
import '../features/auth/view_models/auth_session.dart';
import '../features/auth/views/login_view.dart';
import '../features/contribute/views/contribute_view.dart';
import '../features/heritage/views/heritage_views.dart';
import '../features/landing/views/landing_view.dart';
import '../features/learn/views/learn_views.dart';
import '../features/settings/view_models/settings_view_model.dart';
import '../features/settings/views/settings_view.dart';
import '../features/translate/views/translate_view.dart';
import 'app_routes.dart';
import 'app_shell.dart';
import 'app_theme.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    // Must follow browser path (/app/login → /login), not always /translate.
    initialLocation: resolveInitialLocation(),
    refreshListenable: refresh,
    redirect: (context, state) {
      final path = state.uri.path;
      if (path.length > 1 && path.endsWith('/')) {
        return path.substring(0, path.length - 1);
      }
      final authAsync = ref.read(authSessionProvider);
      final loc = state.matchedLocation;
      final onAuthGate = loc == '/login' || loc == '/register';
      // Never bounce auth screens while session is still restoring.
      if (authAsync.isLoading || !authAsync.hasValue) {
        return null;
      }
      final auth = authAsync.requireValue;
      // Only signed-in users leave login/register → next / staff admin / translate.
      if (auth.isAuthenticated && onAuthGate) {
        final next = state.uri.queryParameters['next'];
        if (next != null && next.isNotEmpty) return next;
        final role = auth.user?.role;
        if (role == 'admin' || role == 'reviewer') return '/admin';
        return '/translate';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/translate'),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const LandingView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/translate',
                builder: (context, state) => const TranslateView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/heritage',
                builder: (context, state) => const HeritageListView(),
                routes: [
                  GoRoute(
                    path: ':slug',
                    builder: (context, state) =>
                        HeritageDetailView(slug: state.pathParameters['slug']!),
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
                    builder: (context, state) =>
                        QuizView(lessonId: state.pathParameters['lessonId']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contribute',
                builder: (context, state) => const ContributeView(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginView(
          initialRegister: state.uri.queryParameters['mode'] == 'register',
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const LoginView(initialRegister: true),
      ),
    ],
  );
});

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(this._ref) {
    _subscription = _ref.listen(authSessionProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<AuthState>> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

class NgonSacVietApp extends ConsumerWidget {
  const NgonSacVietApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
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
