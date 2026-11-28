import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../wiring.dart';
import 'api_client.dart';

class GoogleAuthUnavailable implements Exception {
  GoogleAuthUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

String? _initializedClientId;
Future<void>? _initFuture;

Future<void> _ensureInitialized(GoogleSignIn google, String clientId) {
  if (_initializedClientId == clientId && _initFuture != null) {
    return _initFuture!;
  }
  _initializedClientId = clientId;
  _initFuture = google.initialize(clientId: clientId);
  return _initFuture!;
}

/// Returns a Google ID token or OAuth2 access token for `/v1/auth/google`.
Future<String> signInWithGoogleIdToken({ApiClient? api}) async {
  var clientId = googleClientId.trim();
  if (clientId.isEmpty && api != null) {
    try {
      clientId = await api.guard(api.googleClientIdConfig());
    } catch (_) {
      clientId = '';
    }
  }
  if (clientId.isEmpty) {
    throw GoogleAuthUnavailable(
      'Chưa cấu hình Google Web Client ID (GOOGLE_CLIENT_IDS trên máy chủ). Hãy thêm Client ID từ Google Cloud Console.',
    );
  }

  final google = GoogleSignIn.instance;
  try {
    await _ensureInitialized(google, clientId);
    if (kIsWeb || !google.supportsAuthenticate()) {
      final authz = await google.authorizationClient.authorizeScopes(
        const ['email', 'profile', 'openid'],
      );
      final token = authz.accessToken.trim();
      if (token.isEmpty) {
        throw GoogleAuthUnavailable('Google không trả về access token.');
      }
      return token;
    }

    final account = await google.authenticate(
      scopeHint: const ['email', 'profile'],
    );
    final token = account.authentication.idToken?.trim();
    if (token == null || token.isEmpty) {
      throw GoogleAuthUnavailable('Google không trả về id_token.');
    }
    return token;
  } on GoogleSignInException catch (exc) {
    switch (exc.code) {
      case GoogleSignInExceptionCode.canceled:
        throw GoogleAuthUnavailable('Bạn đã hủy đăng nhập Google.');
      case GoogleSignInExceptionCode.uiUnavailable:
        throw GoogleAuthUnavailable(
          'Trình duyệt đang chặn cửa sổ bật lên (pop-up) Google. Hãy cho phép pop-up và thử lại.',
        );
      default:
        throw GoogleAuthUnavailable(
          exc.description?.isNotEmpty == true
              ? 'Đăng nhập Google thất bại: ${exc.description}'
              : 'Đăng nhập Google thất bại (${exc.code.name}).',
        );
    }
  }
}
