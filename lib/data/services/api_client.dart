import 'package:dio/dio.dart';

import '../../domain/models/heritage_post.dart';
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

  String resolveUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final base = _dio.options.baseUrl.replaceAll(RegExp(r'/+$'), '');
    final suffix = path.startsWith('/') ? path : '/$path';
    return '$base$suffix';
  }

  String ttsUrl({required String text, required String lang}) {
    final cleanText = text.trim();
    final trimmed = cleanText.length > 550 ? cleanText.substring(0, 550) : cleanText;
    return '${resolveUrl('/v1/translate/tts')}?lang=${Uri.encodeQueryComponent(lang)}&text=${Uri.encodeQueryComponent(trimmed)}';
  }

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

  Future<TranslationResult> translateImage({
    required List<int> bytes,
    required String filename,
    required String sourceLang,
    required String targetLang,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
      'source_lang': sourceLang,
      'target_lang': targetLang,
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/translate/image',
      data: form,
    );
    return TranslationResult.fromJson(response.data!);
  }

  Future<TranslationResult> translateSpeech({
    required List<int> bytes,
    required String filename,
    required String sourceLang,
    required String targetLang,
    String? contentType,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: contentType != null ? DioMediaType.parse(contentType) : null,
      ),
      'source_lang': sourceLang,
      'target_lang': targetLang,
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/translate/speech',
      data: form,
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

  Future<TokenPair> loginWithGoogle(String idToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/auth/google',
      data: {'id_token': idToken},
    );
    return TokenPair.fromJson(response.data!);
  }

  Future<TokenPair> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/auth/refresh',
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skipAuthRefresh': true}),
    );
    return TokenPair.fromJson(response.data!);
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post<void>(
      '/v1/auth/logout',
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skipAuthRefresh': true}),
    );
  }

  Future<UserProfile> me() async {
    final response = await _dio.get<Map<String, dynamic>>('/v1/auth/me');
    return UserProfile.fromJson(response.data!);
  }

  Future<Map<String, dynamic>> adminStats() async {
    final response = await _dio.get<Map<String, dynamic>>('/v1/admin/stats');
    return response.data!;
  }

  Future<List<UserProfile>> adminUsers() async {
    final response = await _dio.get<List<dynamic>>('/v1/admin/users');
    return response.data!
        .map((row) => UserProfile.fromJson(_map(row)))
        .toList();
  }

  Future<UserProfile> setUserRole(String userId, String role) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/v1/admin/users/$userId/role',
      data: {'role': role},
    );
    return UserProfile.fromJson(response.data!);
  }

  Future<List<Map<String, dynamic>>> adminLessons({String? languageCode}) async {
    final response = await _dio.get<List<dynamic>>(
      '/v1/admin/lessons',
      queryParameters: {
        if (languageCode != null && languageCode.isNotEmpty) 'language_code': languageCode,
      },
    );
    return response.data!.map(_map).toList();
  }

  Future<Map<String, dynamic>> adminLesson(String lessonId) async {
    final response = await _dio.get<Map<String, dynamic>>('/v1/admin/lessons/$lessonId');
    return response.data!;
  }

  Future<Map<String, dynamic>> updateAdminLesson(
    String lessonId, {
    String? titleVi,
    String? titleEn,
    String? summaryVi,
    String? summaryEn,
    String? level,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/v1/admin/lessons/$lessonId',
      data: {
        if (titleVi != null) 'title_vi': titleVi,
        if (titleEn != null) 'title_en': titleEn,
        if (summaryVi != null) 'summary_vi': summaryVi,
        if (summaryEn != null) 'summary_en': summaryEn,
        if (level != null) 'level': level,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> addAdminPhrase(
    String lessonId, {
    required String nativeText,
    required String viText,
    String enText = '',
    bool verified = false,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/admin/lessons/$lessonId/phrases',
      data: {
        'native_text': nativeText,
        'vi_text': viText,
        'en_text': enText,
        'verified': verified,
        'source': 'admin:console',
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> updateAdminPhrase(
    String phraseId, {
    String? nativeText,
    String? viText,
    String? enText,
    bool? verified,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/v1/admin/phrases/$phraseId',
      data: {
        if (nativeText != null) 'native_text': nativeText,
        if (viText != null) 'vi_text': viText,
        if (enText != null) 'en_text': enText,
        if (verified != null) 'verified': verified,
      },
    );
    return response.data!;
  }

  Future<void> deleteAdminPhrase(String phraseId) async {
    await _dio.delete<void>('/v1/admin/phrases/$phraseId');
  }

  Future<List<Contribution>> reviewQueue({String status = 'pending', String? languageCode}) async {
    final response = await _dio.get<List<dynamic>>(
      '/v1/contributions',
      queryParameters: {
        'status': status,
        if (languageCode != null && languageCode.isNotEmpty) 'language_code': languageCode,
      },
    );
    return response.data!.map((row) => Contribution.fromJson(_map(row))).toList();
  }

  Future<Contribution> reviewContribution({
    required String id,
    required String status,
    String? reviewNote,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/contributions/$id/review',
      data: {
        'status': status,
        if (reviewNote != null && reviewNote.trim().isNotEmpty) 'review_note': reviewNote.trim(),
      },
    );
    return Contribution.fromJson(response.data!);
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

  Future<List<HeritagePost>> listHeritagePosts({
    String status = 'approved',
    bool mine = false,
    String? peopleSlug,
    String? mediaType,
    String? query,
    int limit = 30,
    int offset = 0,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/v1/heritage/posts',
      queryParameters: {
        'status': status,
        if (mine) 'mine': true,
        if (peopleSlug != null && peopleSlug.isNotEmpty && peopleSlug != 'all')
          'people_slug': peopleSlug,
        if (mediaType != null && mediaType.isNotEmpty && mediaType != 'all')
          'media_type': mediaType,
        if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
        'limit': limit,
        'offset': offset,
      },
    );
    return response.data!.map((row) => HeritagePost.fromJson(_map(row))).toList();
  }

  Future<HeritagePost> createHeritagePost({
    required String title,
    required String body,
    String? peopleSlug,
    List<int>? fileBytes,
    String? filename,
    String? contentType,
  }) async {
    final map = <String, dynamic>{
      'title': title,
      'body': body,
      if (peopleSlug != null && peopleSlug.isNotEmpty && peopleSlug != 'all')
        'people_slug': peopleSlug,
    };
    if (fileBytes != null && filename != null) {
      map['file'] = MultipartFile.fromBytes(
        fileBytes,
        filename: filename,
        contentType: contentType != null ? DioMediaType.parse(contentType) : null,
      );
    }
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/heritage/posts',
      data: FormData.fromMap(map),
    );
    return HeritagePost.fromJson(response.data!);
  }

  Future<HeritagePost> reviewHeritagePost({
    required String postId,
    required String status,
    String? reviewNote,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/heritage/posts/$postId/review',
      data: {
        'status': status,
        if (reviewNote != null && reviewNote.trim().isNotEmpty)
          'review_note': reviewNote.trim(),
      },
    );
    return HeritagePost.fromJson(response.data!);
  }

  Future<({bool liked, int likeCount})> toggleHeritageLike(String postId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/heritage/posts/$postId/like',
    );
    final data = response.data!;
    return (
      liked: data['liked'] == true,
      likeCount: (data['like_count'] as num?)?.toInt() ?? 0,
    );
  }

  Future<List<HeritageComment>> listHeritageComments(String postId) async {
    final response = await _dio.get<List<dynamic>>(
      '/v1/heritage/posts/$postId/comments',
    );
    return response.data!
        .map((row) => HeritageComment.fromJson(_map(row)))
        .toList();
  }

  Future<HeritageComment> addHeritageComment(String postId, String body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/heritage/posts/$postId/comments',
      data: {'body': body},
    );
    return HeritageComment.fromJson(response.data!);
  }

  Future<void> deleteHeritagePost(String postId) async {
    await _dio.delete<void>('/v1/heritage/posts/$postId');
  }

  Future<HeritagePostTranslation> translateHeritagePost({
    required String postId,
    required String targetLang,
    String sourceLang = 'auto',
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/heritage/posts/$postId/translate',
      data: {'target_lang': targetLang, 'source_lang': sourceLang},
    );
    return HeritagePostTranslation.fromJson(response.data!);
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
