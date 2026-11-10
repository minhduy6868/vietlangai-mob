import 'package:dio/dio.dart';

import '../../domain/models/models.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.status});

  final String message;
  final int? status;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<SyncSnapshot> pullCatalog() async {
    final response = await _dio.get<Map<String, dynamic>>('/v1/sync/pull');
    return SyncSnapshot.fromJson(response.data!);
  }

  Future<List<Contribution>> pushContributions(List<Contribution> rows) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/sync/push',
      data: {
        'contributions': rows
            .map(
              (row) => {
                'client_id': row.clientId,
                'language_code': row.languageCode,
                'source_lang': row.sourceLang,
                'target_lang': row.targetLang,
                'source_text': row.sourceText,
                'target_text': row.targetText,
                'note': row.note,
              },
            )
            .toList(),
      },
    );
    final list = response.data!['contributions'] as List<dynamic>;
    return list.map((row) => Contribution.fromJson(_map(row))).toList();
  }

  Future<TranslationResult> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/translate',
      data: {'text': text, 'source_lang': sourceLang, 'target_lang': targetLang},
    );
    return TranslationResult.fromJson(response.data!);
  }

  Future<TokenPair> login(String email, String password) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/auth/login',
      data: {'email': email, 'password': password},
    );
    return TokenPair.fromJson(response.data!);
  }

  Future<TokenPair> register(String email, String password, String displayName) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/auth/register',
      data: {'email': email, 'password': password, 'display_name': displayName},
    );
    return TokenPair.fromJson(response.data!);
  }

  Future<QuizScore> submitQuiz(String lessonId, Map<String, String> answers) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/lessons/$lessonId/quiz',
      data: {
        'answers': answers.entries
            .map((entry) => {'question_id': entry.key, 'choice_id': entry.value})
            .toList(),
      },
    );
    return QuizScore.fromJson(response.data!);
  }

  Future<T> guard<T>(Future<T> future) async {
    try {
      return await future;
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is Map && data['detail'] is Map
          ? data['detail']['message']?.toString() ?? 'Request failed'
          : error.message ?? 'Request failed';
      throw ApiException(message, status: error.response?.statusCode);
    }
  }
}

Map<String, dynamic> _map(Object? row) => Map<String, dynamic>.from(row as Map);
