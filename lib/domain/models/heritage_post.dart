class HeritageComment {
  const HeritageComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.authorName,
    required this.body,
    this.createdAt,
  });

  final String id;
  final String postId;
  final String userId;
  final String authorName;
  final String body;
  final DateTime? createdAt;

  factory HeritageComment.fromJson(Map<String, dynamic> json) {
    return HeritageComment(
      id: (json['id'] ?? '').toString(),
      postId: (json['post_id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      authorName: (json['author_name'] ?? 'Thành viên').toString(),
      body: (json['body'] ?? '').toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

class HeritagePost {
  const HeritagePost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.body,
    required this.mediaType,
    required this.status,
    required this.likeCount,
    required this.commentCount,
    required this.likedByMe,
    this.recentComments = const [],
    this.peopleSlug,
    this.mediaMime,
    this.mediaFilename,
    this.mediaUrl,
    this.thumbUrl,
    this.telegramMessageId,
    this.telegramUrl,
    this.reviewNote,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String? peopleSlug;
  final String title;
  final String body;
  final String mediaType;
  final String? mediaMime;
  final String? mediaFilename;
  final String? mediaUrl;
  final String? thumbUrl;
  final int? telegramMessageId;
  final String? telegramUrl;
  final String status;
  final String? reviewNote;
  final int likeCount;
  final int commentCount;
  final bool likedByMe;
  final List<HeritageComment> recentComments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory HeritagePost.fromJson(Map<String, dynamic> json) {
    final rawComments = json['recent_comments'] as List<dynamic>? ?? const [];
    return HeritagePost(
      id: (json['id'] ?? '').toString(),
      authorId: (json['author_id'] ?? '').toString(),
      authorName: (json['author_name'] ?? 'Thành viên').toString(),
      peopleSlug: json['people_slug']?.toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      mediaType: (json['media_type'] ?? 'text').toString(),
      mediaMime: json['media_mime']?.toString(),
      mediaFilename: json['media_filename']?.toString(),
      mediaUrl: json['media_url']?.toString(),
      thumbUrl: json['thumb_url']?.toString(),
      telegramMessageId: (json['telegram_message_id'] as num?)?.toInt(),
      telegramUrl: json['telegram_url']?.toString(),
      status: (json['status'] ?? 'pending').toString(),
      reviewNote: json['review_note']?.toString(),
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
      likedByMe: json['liked_by_me'] == true,
      recentComments: rawComments
          .whereType<Map>()
          .map((row) => HeritageComment.fromJson(Map<String, dynamic>.from(row)))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  HeritagePost copyWith({
    String? status,
    String? reviewNote,
    int? likeCount,
    int? commentCount,
    bool? likedByMe,
    List<HeritageComment>? recentComments,
  }) {
    return HeritagePost(
      id: id,
      authorId: authorId,
      authorName: authorName,
      peopleSlug: peopleSlug,
      title: title,
      body: body,
      mediaType: mediaType,
      mediaMime: mediaMime,
      mediaFilename: mediaFilename,
      mediaUrl: mediaUrl,
      thumbUrl: thumbUrl,
      telegramMessageId: telegramMessageId,
      telegramUrl: telegramUrl,
      status: status ?? this.status,
      reviewNote: reviewNote ?? this.reviewNote,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likedByMe: likedByMe ?? this.likedByMe,
      recentComments: recentComments ?? this.recentComments,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class HeritagePostTranslation {
  const HeritagePostTranslation({
    required this.postId,
    required this.sourceLang,
    required this.targetLang,
    required this.translatedTitle,
    required this.translatedBody,
    required this.engine,
    required this.route,
    this.warnings = const [],
  });

  final String postId;
  final String sourceLang;
  final String targetLang;
  final String translatedTitle;
  final String translatedBody;
  final String engine;
  final String route;
  final List<String> warnings;

  factory HeritagePostTranslation.fromJson(Map<String, dynamic> json) {
    final rawWarnings = json['warnings'] as List<dynamic>? ?? const [];
    return HeritagePostTranslation(
      postId: (json['post_id'] ?? '').toString(),
      sourceLang: (json['source_lang'] ?? 'vi').toString(),
      targetLang: (json['target_lang'] ?? '').toString(),
      translatedTitle: (json['translated_title'] ?? '').toString(),
      translatedBody: (json['translated_body'] ?? '').toString(),
      engine: (json['engine'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      warnings: rawWarnings.map((item) => item.toString()).toList(),
    );
  }
}
