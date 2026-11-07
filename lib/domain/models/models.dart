import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class Language with _$Language {
  const factory Language({
    required String code,
    @JsonKey(name: 'iso639_3') required String iso6393,
    required String nameVi,
    required String nameEn,
    required String script,
    required String family,
    required String role,
    required int evaluationTier,
    required String orthography,
  }) = _Language;

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
}

@freezed
abstract class People with _$People {
  const factory People({
    required String slug,
    required String nameVi,
    required String nameEn,
    required String family,
    required String regionVi,
    required String regionEn,
    required String languageCode,
    String? originVi,
    String? originEn,
  }) = _People;

  factory People.fromJson(Map<String, dynamic> json) => _$PeopleFromJson(json);
}

@freezed
abstract class HeritageItem with _$HeritageItem {
  const factory HeritageItem({
    required String id,
    required String kind,
    required String titleVi,
    required String titleEn,
    required String bodyVi,
    required String bodyEn,
    String? mediaUrl,
    String? groupSlug,
  }) = _HeritageItem;

  factory HeritageItem.fromJson(Map<String, dynamic> json) =>
      _$HeritageItemFromJson(json);
}

@freezed
abstract class Phrase with _$Phrase {
  const factory Phrase({
    required String id,
    required String nativeText,
    required String viText,
    required String enText,
    String? source,
  }) = _Phrase;

  factory Phrase.fromJson(Map<String, dynamic> json) => _$PhraseFromJson(json);
}

@freezed
abstract class QuizChoice with _$QuizChoice {
  const factory QuizChoice({
    required String id,
    required String textVi,
    required String textEn,
  }) = _QuizChoice;

  factory QuizChoice.fromJson(Map<String, dynamic> json) =>
      _$QuizChoiceFromJson(json);
}

@freezed
abstract class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    required String promptVi,
    required String promptEn,
    @Default([]) List<QuizChoice> choices,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String languageCode,
    required String titleVi,
    required String titleEn,
    required String summaryVi,
    required String summaryEn,
    required String level,
    @Default([]) List<Phrase> phrases,
    @Default([]) List<QuizQuestion> questions,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}

@freezed
abstract class Contribution with _$Contribution {
  const factory Contribution({
    required String clientId,
    required String languageCode,
    required String sourceLang,
    required String targetLang,
    required String sourceText,
    required String targetText,
    String? id,
    String? note,
    @Default('pending') String status,
    String? reviewNote,
  }) = _Contribution;

  factory Contribution.fromJson(Map<String, dynamic> json) =>
      _$ContributionFromJson(json);
}

@freezed
abstract class TranslationStep with _$TranslationStep {
  const factory TranslationStep({
    required String source,
    required String target,
    required String engine,
    required String text,
  }) = _TranslationStep;

  factory TranslationStep.fromJson(Map<String, dynamic> json) =>
      _$TranslationStepFromJson(json);
}

@freezed
abstract class TranslationResult with _$TranslationResult {
  const factory TranslationResult({
    required String text,
    required String sourceLang,
    required String targetLang,
    String? detectedLang,
    String? recognizedText,
    required String route,
    required String engine,
    @Default([]) List<String> warnings,
    @Default([]) List<TranslationStep> steps,
  }) = _TranslationResult;

  factory TranslationResult.fromJson(Map<String, dynamic> json) =>
      _$TranslationResultFromJson(json);
}

@freezed
abstract class TokenPair with _$TokenPair {
  const factory TokenPair({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
  }) = _TokenPair;

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String displayName,
    required String role,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
abstract class SyncSnapshot with _$SyncSnapshot {
  const factory SyncSnapshot({
    required List<Language> languages,
    required List<People> peoples,
    required List<HeritageItem> heritage,
    required List<Lesson> lessons,
    @Default([]) List<Contribution> approvedContributions,
  }) = _SyncSnapshot;

  factory SyncSnapshot.fromJson(Map<String, dynamic> json) =>
      _$SyncSnapshotFromJson(json);
}

@freezed
abstract class QuizScore with _$QuizScore {
  const factory QuizScore({
    required int score,
    required int total,
  }) = _QuizScore;

  factory QuizScore.fromJson(Map<String, dynamic> json) =>
      _$QuizScoreFromJson(json);
}
