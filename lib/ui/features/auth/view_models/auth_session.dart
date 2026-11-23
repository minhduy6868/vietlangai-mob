import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/session_profile.dart';
import '../../../../data/wiring.dart';
import '../../../../domain/models/models.dart';
import '../../../../data/services/api_client.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        message = null;

  final AuthStatus status;
  final UserProfile? user;
  final String? message;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? message,
    bool clearUser = false,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

class AuthSessionNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return _restore();
  }

  Future<AuthState> _restore() async {
    final tokens = ref.read(tokenStoreProvider);
    final has = await tokens.hasTokens();
    if (!has) {
      return const AuthState(
        status: AuthStatus.unauthenticated,
      );
    }

    final api = ref.read(apiClientProvider);
    try {
      final user = await api.guard(api.me());
      await ref.read(sessionProfileProvider.notifier).save(
            displayName: user.displayName,
            email: user.email,
          );
      return AuthState(status: AuthStatus.authenticated, user: user);
    } on ApiException catch (error) {
      if (error.status == 401) {
        final refreshed = await _tryRefresh();
        if (refreshed != null) {
          return refreshed;
        }
      }
      await tokens.clear();
      await ref.read(sessionProfileProvider.notifier).clear();
      return AuthState(
        status: AuthStatus.unauthenticated,
        message: error.message,
      );
    } catch (_) {
      await tokens.clear();
      await ref.read(sessionProfileProvider.notifier).clear();
      return const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<AuthState?> _tryRefresh() async {
    final tokens = ref.read(tokenStoreProvider);
    final refresh = await tokens.readRefresh();
    if (refresh == null || refresh.isEmpty) return null;
    final api = ref.read(apiClientProvider);
    try {
      final pair = await api.guard(api.refresh(refresh));
      await tokens.save(pair);
      final user = await api.guard(api.me());
      await ref.read(sessionProfileProvider.notifier).save(
            displayName: user.displayName,
            email: user.email,
          );
      return AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      return null;
    }
  }

  Future<void> markAuthenticated(UserProfile user) async {
    state = AsyncData(
      AuthState(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> refreshSession() async {
    state = const AsyncData(AuthState(status: AuthStatus.loading));
    state = AsyncData(await _restore());
  }

  Future<void> logout() async {
    final tokens = ref.read(tokenStoreProvider);
    final refresh = await tokens.readRefresh();
    if (refresh != null && refresh.isNotEmpty) {
      try {
        await ref.read(apiClientProvider).logout(refresh);
      } catch (_) {
        // Best-effort revoke; always clear local session.
      }
    }
    await tokens.clear();
    await ref.read(sessionProfileProvider.notifier).clear();
    state = const AsyncData(AuthState(status: AuthStatus.unauthenticated));
  }
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, AuthState>(
  AuthSessionNotifier.new,
);
