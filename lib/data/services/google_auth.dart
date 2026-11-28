import 'package:google_sign_in/google_sign_in.dart';

import '../wiring.dart';
import 'api_client.dart';

class GoogleAuthUnavailable implements Exception {
  GoogleAuthUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Returns a Google ID token for the API `/v1/auth/google` exchange.
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
  await google.initialize(clientId: clientId);
  final account = await google.authenticate(
    scopeHint: const ['email', 'profile'],
  );
  final token = account.authentication.idToken;
  if (token == null || token.isEmpty) {
    throw GoogleAuthUnavailable('Google không trả về id_token.');
  }
  return token;
}
