import 'package:flutter/foundation.dart';

/// Resolve the first GoRouter location from the browser URL.
///
/// With `--base-href /app/`, the browser path looks like `/app/login`.
/// GoRouter routes are `/login`, `/register`, `/translate`, ...
String resolveInitialLocation() {
  if (!kIsWeb) return '/translate';

  var path = Uri.base.path;
  if (path.endsWith('/index.html')) {
    path = path.substring(0, path.length - '/index.html'.length);
  }
  if (path.startsWith('/app')) {
    path = path.substring('/app'.length);
  }
  if (path.isEmpty || path == '/') return '/translate';
  if (!path.startsWith('/')) path = '/$path';
  if (path.length > 1 && path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }
  // Legacy
  if (path == '/welcome') return '/translate';
  return path;
}

bool isAuthDeepLink([String? location]) {
  final path = location ?? resolveInitialLocation();
  return path == '/login' ||
      path == '/register' ||
      path.startsWith('/login?') ||
      path.startsWith('/register?');
}
