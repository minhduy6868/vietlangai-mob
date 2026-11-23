import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/models.dart';
import '../domain/sync_use_case.dart';
import 'providers.dart';
import 'services/api_client.dart';
import 'services/catalog_sources.dart';
import 'services/token_store.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'http://127.0.0.1:8000',
);
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
const googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');

final tokenStoreProvider = Provider<TokenStore>(
  (ref) => TokenStore(const FlutterSecureStorage()),
);

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  final tokens = ref.watch(tokenStoreProvider);
  var refreshing = false;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await tokens.readAccess();
        if (access != null && access.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final response = error.response;
        final request = error.requestOptions;
        final skip = request.extra['skipAuthRefresh'] == true;
        final path = request.path;
        final isAuthPath = path.contains('/v1/auth/login') ||
            path.contains('/v1/auth/register') ||
            path.contains('/v1/auth/refresh') ||
            path.contains('/v1/auth/logout') ||
            path.contains('/v1/auth/google');

        if (response?.statusCode != 401 || skip || isAuthPath || refreshing) {
          return handler.next(error);
        }

        final refreshToken = await tokens.readRefresh();
        if (refreshToken == null || refreshToken.isEmpty) {
          await tokens.clear();
          return handler.next(error);
        }

        refreshing = true;
        try {
          final refreshResponse = await dio.post<Map<String, dynamic>>(
            '/v1/auth/refresh',
            data: {'refresh_token': refreshToken},
            options: Options(extra: {'skipAuthRefresh': true}),
          );
          final data = refreshResponse.data;
          if (data == null) {
            await tokens.clear();
            return handler.next(error);
          }
          final pair = TokenPair.fromJson(data);
          await tokens.save(pair);

          final headers = Map<String, dynamic>.from(request.headers);
          headers['Authorization'] = 'Bearer ${pair.accessToken}';
          final clone = await dio.request<dynamic>(
            request.path,
            data: request.data,
            queryParameters: request.queryParameters,
            options: Options(
              method: request.method,
              headers: headers,
              responseType: request.responseType,
              contentType: request.contentType,
              extra: {...request.extra, 'skipAuthRefresh': true},
            ),
          );
          return handler.resolve(clone);
        } catch (_) {
          await tokens.clear();
          return handler.next(error);
        } finally {
          refreshing = false;
        }
      },
    ),
  );
  return dio;
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);

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
    return (rows as List<dynamic>)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }
}
