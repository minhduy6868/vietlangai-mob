import 'package:google_sign_in/google_sign_in.dart';

import '../wiring.dart';

class GoogleAuthUnavailable implements Exception {
  GoogleAuthUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Returns a Google ID token for the API `/v1/auth/google` exchange.
Future<String> signInWithGoogleIdToken() async {
  if (googleClientId.isEmpty) {
    throw GoogleAuthUnavailable(
      'Thiếu GOOGLE_CLIENT_ID. Thêm Client ID Web từ Google Cloud vào bản build.',
    );
  }

  final google = GoogleSignIn.instance;
  await google.initialize(clientId: googleClientId);
  final account = await google.authenticate(
    scopeHint: const ['email', 'profile'],
  );
  final token = account.authentication.idToken;
  if (token == null || token.isEmpty) {
    throw GoogleAuthUnavailable('Google không trả về id_token.');
  }
  return token;
}
