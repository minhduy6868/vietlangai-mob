import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/sync_use_case.dart';
import 'providers.dart';
import 'services/api_client.dart';
import 'services/catalog_sources.dart';
import 'services/token_store.dart';

const apiBaseUrl = String.fromEnvironment('API_BASE', defaultValue: 'http://127.0.0.1:8000');
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore(const FlutterSecureStorage()));

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  final tokens = ref.watch(tokenStoreProvider);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await tokens.readAccess();
        if (access != null) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        handler.next(options);
      },
    ),
  );
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(ref.watch(dioProvider)));

final syncUseCaseProvider = Provider<SyncUseCase>((ref) {
  final api = ref.watch(apiClientProvider);
  final CatalogSource catalog = supabaseUrl.isEmpty
      ? ApiCatalogSource(api)
      : SupabaseCatalogSource(_SupabaseTables(Supabase.instance.client));
  return SyncUseCase(
    local: ref.watch(localStoreProvider),
    catalog: catalog,
    contributions: ApiContributionSink(api),
  );
});

class _SupabaseTables implements TableReader {
  _SupabaseTables(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> select(String table) async {
    final rows = await _client.from(table).select();
    return (rows as List<dynamic>).map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }
}
