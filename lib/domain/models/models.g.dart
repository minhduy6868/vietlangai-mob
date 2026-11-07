// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Language _$LanguageFromJson(Map<String, dynamic> json) => _Language(
  code: json['code'] as String,
  iso6393: json['iso639_3'] as String,
  nameVi: json['name_vi'] as String,
  nameEn: json['name_en'] as String,
  script: json['script'] as String,
  family: json['family'] as String,
  role: json['role'] as String,
  evaluationTier: (json['evaluation_tier'] as num).toInt(),
  orthography: json['orthography'] as String,
);

Map<String, dynamic> _$LanguageToJson(_Language instance) => <String, dynamic>{
  'code': instance.code,
  'iso639_3': instance.iso6393,
  'name_vi': instance.nameVi,
  'name_en': instance.nameEn,
  'script': instance.script,
  'family': instance.family,
  'role': instance.role,
  'evaluation_tier': instance.evaluationTier,
  'orthography': instance.orthography,
};

_People _$PeopleFromJson(Map<String, dynamic> json) => _People(
  slug: json['slug'] as String,
  nameVi: json['name_vi'] as String,
  nameEn: json['name_en'] as String,
  family: json['family'] as String,
  regionVi: json['region_vi'] as String,
  regionEn: json['region_en'] as String,
  languageCode: json['language_code'] as String,
  originVi: json['origin_vi'] as String?,
  originEn: json['origin_en'] as String?,
);

Map<String, dynamic> _$PeopleToJson(_People instance) => <String, dynamic>{
  'slug': instance.slug,
  'name_vi': instance.nameVi,
  'name_en': instance.nameEn,
  'family': instance.family,
  'region_vi': instance.regionVi,
  'region_en': instance.regionEn,
  'language_code': instance.languageCode,
  'origin_vi': instance.originVi,
  'origin_en': instance.originEn,
};

_HeritageItem _$HeritageItemFromJson(Map<String, dynamic> json) =>
    _HeritageItem(
      id: json['id'] as String,
      kind: json['kind'] as String,
      titleVi: json['title_vi'] as String,
      titleEn: json['title_en'] as String,
      bodyVi: json['body_vi'] as String,
      bodyEn: json['body_en'] as String,
      mediaUrl: json['media_url'] as String?,
      groupSlug: json['group_slug'] as String?,
    );

Map<String, dynamic> _$HeritageItemToJson(_HeritageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'title_vi': instance.titleVi,
      'title_en': instance.titleEn,
      'body_vi': instance.bodyVi,
      'body_en': instance.bodyEn,
      'media_url': instance.mediaUrl,
      'group_slug': instance.groupSlug,
    };

_Phrase _$PhraseFromJson(Map<String, dynamic> json) => _Phrase(
  id: json['id'] as String,
  nativeText: json['native_text'] as String,
  viText: json['vi_text'] as String,
  enText: json['en_text'] as String,
  source: json['source'] as String?,
);

Map<String, dynamic> _$PhraseToJson(_Phrase instance) => <String, dynamic>{
  'id': instance.id,
  'native_text': instance.nativeText,
  'vi_text': instance.viText,
  'en_text': instance.enText,
  'source': instance.source,
};

_QuizChoice _$QuizChoiceFromJson(Map<String, dynamic> json) => _QuizChoice(
  id: json['id'] as String,
  textVi: json['text_vi'] as String,
  textEn: json['text_en'] as String,
);

Map<String, dynamic> _$QuizChoiceToJson(_QuizChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text_vi': instance.textVi,
      'text_en': instance.textEn,
    };

_QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) =>
    _QuizQuestion(
      id: json['id'] as String,
      promptVi: json['prompt_vi'] as String,
      promptEn: json['prompt_en'] as String,
      choices:
          (json['choices'] as List<dynamic>?)
              ?.map((e) => QuizChoice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuizQuestionToJson(_QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prompt_vi': instance.promptVi,
      'prompt_en': instance.promptEn,
      'choices': instance.choices.map((e) => e.toJson()).toList(),
    };

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: json['id'] as String,
  languageCode: json['language_code'] as String,
  titleVi: json['title_vi'] as String,
  titleEn: json['title_en'] as String,
  summaryVi: json['summary_vi'] as String,
  summaryEn: json['summary_en'] as String,
  level: json['level'] as String,
  phrases:
      (json['phrases'] as List<dynamic>?)
          ?.map((e) => Phrase.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'language_code': instance.languageCode,
  'title_vi': instance.titleVi,
  'title_en': instance.titleEn,
  'summary_vi': instance.summaryVi,
  'summary_en': instance.summaryEn,
  'level': instance.level,
  'phrases': instance.phrases.map((e) => e.toJson()).toList(),
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

_Contribution _$ContributionFromJson(Map<String, dynamic> json) =>
    _Contribution(
      clientId: json['client_id'] as String,
      languageCode: json['language_code'] as String,
      sourceLang: json['source_lang'] as String,
      targetLang: json['target_lang'] as String,
      sourceText: json['source_text'] as String,
      targetText: json['target_text'] as String,
      id: json['id'] as String?,
      note: json['note'] as String?,
      status: json['status'] as String? ?? 'pending',
      reviewNote: json['review_note'] as String?,
    );

Map<String, dynamic> _$ContributionToJson(_Contribution instance) =>
    <String, dynamic>{
      'client_id': instance.clientId,
      'language_code': instance.languageCode,
      'source_lang': instance.sourceLang,
      'target_lang': instance.targetLang,
      'source_text': instance.sourceText,
      'target_text': instance.targetText,
      'id': instance.id,
      'note': instance.note,
      'status': instance.status,
      'review_note': instance.reviewNote,
    };

_TranslationStep _$TranslationStepFromJson(Map<String, dynamic> json) =>
    _TranslationStep(
      source: json['source'] as String,
      target: json['target'] as String,
      engine: json['engine'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$TranslationStepToJson(_TranslationStep instance) =>
    <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
      'engine': instance.engine,
      'text': instance.text,
    };

_TranslationResult _$TranslationResultFromJson(Map<String, dynamic> json) =>
    _TranslationResult(
      text: json['text'] as String,
      sourceLang: json['source_lang'] as String,
      targetLang: json['target_lang'] as String,
      detectedLang: json['detected_lang'] as String?,
      recognizedText: json['recognized_text'] as String?,
      route: json['route'] as String,
      engine: json['engine'] as String,
      warnings:
          (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => TranslationStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TranslationResultToJson(_TranslationResult instance) =>
    <String, dynamic>{
      'text': instance.text,
      'source_lang': instance.sourceLang,
      'target_lang': instance.targetLang,
      'detected_lang': instance.detectedLang,
      'recognized_text': instance.recognizedText,
      'route': instance.route,
      'engine': instance.engine,
      'warnings': instance.warnings,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };

_TokenPair _$TokenPairFromJson(Map<String, dynamic> json) => _TokenPair(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  tokenType: json['token_type'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
);

Map<String, dynamic> _$TokenPairToJson(_TokenPair instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
      'role': instance.role,
    };

_SyncSnapshot _$SyncSnapshotFromJson(Map<String, dynamic> json) =>
    _SyncSnapshot(
      languages: (json['languages'] as List<dynamic>)
          .map((e) => Language.fromJson(e as Map<String, dynamic>))
          .toList(),
      peoples: (json['peoples'] as List<dynamic>)
          .map((e) => People.fromJson(e as Map<String, dynamic>))
          .toList(),
      heritage: (json['heritage'] as List<dynamic>)
          .map((e) => HeritageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      approvedContributions:
          (json['approved_contributions'] as List<dynamic>?)
              ?.map((e) => Contribution.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SyncSnapshotToJson(_SyncSnapshot instance) =>
    <String, dynamic>{
      'languages': instance.languages.map((e) => e.toJson()).toList(),
      'peoples': instance.peoples.map((e) => e.toJson()).toList(),
      'heritage': instance.heritage.map((e) => e.toJson()).toList(),
      'lessons': instance.lessons.map((e) => e.toJson()).toList(),
      'approved_contributions': instance.approvedContributions
          .map((e) => e.toJson())
          .toList(),
    };

_QuizScore _$QuizScoreFromJson(Map<String, dynamic> json) => _QuizScore(
  score: (json['score'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$QuizScoreToJson(_QuizScore instance) =>
    <String, dynamic>{'score': instance.score, 'total': instance.total};
