import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/services/google_auth.dart';
import '../../../../data/session_profile.dart';
import '../../../../data/wiring.dart';
import 'auth_session.dart';

class AuthActionResult {
  const AuthActionResult.success({
    required this.message,
    this.role = 'member',
    this.isGoogle = false,
  }) : error = null;

  const AuthActionResult.failure(this.error)
      : message = null,
        role = null,
        isGoogle = false;

  final String? message;
  final String? error;
  final String? role;
  final bool isGoogle;

  bool get ok => error == null;
  bool get isStaff => role == 'admin' || role == 'reviewer';
}

class AuthViewModel extends Notifier<void> {
  @override
  void build() {}

  Future<AuthActionResult> submitEmail({
    required bool register,
    required String email,
    required String password,
    required String displayName,
    required String successLoginLabel,
    required String successRegisterLabel,
  }) async {
    final api = ref.read(apiClientProvider);
    try {
      final tokens = register
          ? await api.guard(api.register(email, password, displayName))
          : await api.guard(api.login(email, password));
      await ref.read(tokenStoreProvider).save(tokens);
      final user = await api.guard(api.me());
      await ref.read(sessionProfileProvider.notifier).save(
            id: user.id,
            displayName: user.displayName,
            email: user.email,
            role: user.role,
          );
      await ref.read(authSessionProvider.notifier).markAuthenticated(user);
      return AuthActionResult.success(
        message: register ? successRegisterLabel : successLoginLabel,
        role: user.role,
      );
    } catch (error) {
      return AuthActionResult.failure(error.toString());
    }
  }

  Future<AuthActionResult> submitGoogle({required String emailFallback}) async {
    final api = ref.read(apiClientProvider);
    try {
      final idToken = await signInWithGoogleIdToken();
      final tokens = await api.guard(api.loginWithGoogle(idToken));
      await ref.read(tokenStoreProvider).save(tokens);
      final user = await api.guard(api.me());
      await ref.read(sessionProfileProvider.notifier).save(
            id: user.id,
            displayName: user.displayName,
            email: user.email.isEmpty ? emailFallback : user.email,
            role: user.role,
          );
      await ref.read(authSessionProvider.notifier).markAuthenticated(user);
      return AuthActionResult.success(
        message: 'Đăng nhập Google thành công',
        role: user.role,
        isGoogle: true,
      );
    } catch (error) {
      return AuthActionResult.failure(error.toString());
    }
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, void>(
  AuthViewModel.new,
);
