import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/models/models.dart';

class TokenStore {
  const TokenStore(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> save(TokenPair pair) async {
    await _storage.write(key: 'access', value: pair.accessToken);
    await _storage.write(key: 'refresh', value: pair.refreshToken);
  }

  Future<String?> readAccess() => _storage.read(key: 'access');

  Future<void> clear() async {
    await _storage.delete(key: 'access');
    await _storage.delete(key: 'refresh');
  }
}
