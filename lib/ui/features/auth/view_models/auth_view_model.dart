import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/services/google_auth.dart';
import '../../../../data/session_profile.dart';
import '../../../../data/wiring.dart';

class AuthActionResult {
  const AuthActionResult.success({
    required this.message,
    this.isGoogle = false,
  }) : error = null;

  const AuthActionResult.failure(this.error)
      : message = null,
        isGoogle = false;

  final String? message;
  final String? error;
  final bool isGoogle;

  bool get ok => error == null;
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
      await ref.read(sessionProfileProvider.notifier).save(
            displayName: register
                ? displayName
                : (displayName.isEmpty ? email : displayName),
            email: email,
          );
      return AuthActionResult.success(
        message: register ? successRegisterLabel : successLoginLabel,
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
      await ref.read(sessionProfileProvider.notifier).save(
            displayName: 'Google',
            email: emailFallback.isEmpty ? 'google@user' : emailFallback,
          );
      return const AuthActionResult.success(
        message: 'Đăng nhập Google thành công',
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
