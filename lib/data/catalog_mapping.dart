import '../domain/models/models.dart';

const _familyPool = [
  'Tai-Kadai',
  'Austronesian, Chamic',
  'Hmong-Mien',
  'Austroasiatic, Vietic',
];

const _scriptLabels = {
  'Latn': 'Latin',
  'Cham': 'Akhar Thrah (Cham)',
};

const _scriptPool = ['Latin', 'Akhar Thrah (Cham)', 'Chữ Thái', 'Chữ Nôm'];

SyncSnapshot snapshotFromBundledCatalog(Map<String, dynamic> json) {
  final languages = (json['languages'] as List<dynamic>)
      .map((row) => Language.fromJson(_map(row)))
      .toList();
  final families = {for (final language in languages) language.code: language.family};
  final peoples = (json['peoples'] as List<dynamic>).map((row) {
    final data = _map(row);
    data['family'] = families[data['language_code']] ?? '';
    return People.fromJson(data);
  }).toList();
  final heritage = (json['heritage'] as List<dynamic>).map((row) {
    final data = _map(row);
    data['id'] = '${data['slug']}:${data['title_vi']}';
    data['group_slug'] = data['slug'];
    return HeritageItem.fromJson(data);
  }).toList();
  final languageByCode = {for (final language in languages) language.code: language};
  final lessons = lessonsFromCatalogMeta(peoples: peoples, languageByCode: languageByCode);
  return SyncSnapshot(
    languages: languages,
    peoples: peoples,
    heritage: heritage,
    lessons: lessons,
  );
}

/// Meta lessons from catalog only: family / script / region quizzes.
/// No ethnic-language sentences are invented here.
List<Lesson> lessonsFromCatalogMeta({
  required List<People> peoples,
  required Map<String, Language> languageByCode,
}) {
  final lessons = <Lesson>[];
  for (final people in peoples) {
    final language = languageByCode[people.languageCode];
    if (language == null || language.role != 'ethnic') continue;
    final lessonId = 'lesson:${people.slug}';
    final scriptLabel = _scriptLabels[language.script] ?? language.script;
    final familyDistractors = _familyPool.where((item) => item != language.family).toList();
    final scriptDistractors = _scriptPool.where((item) => item != scriptLabel).toList();
    final regionDistractors = peoples
        .where((item) => item.slug != people.slug)
        .map((item) => item.regionVi)
        .take(3)
        .toList();

    lessons.add(
      Lesson(
        id: lessonId,
        languageCode: language.code,
        titleVi: 'Làm quen với ${language.nameVi}',
        titleEn: 'Getting started with ${language.nameEn}',
        summaryVi: people.originVi ?? people.regionVi,
        summaryEn: people.originEn ?? people.regionEn,
        level: 'basic',
        phrases: const [],
        questions: [
          _question(
            id: '$lessonId:family',
            promptVi: '${people.nameVi} nói ngôn ngữ thuộc họ nào?',
            promptEn: 'Which family does the language of the ${people.nameEn} belong to?',
            correctVi: language.family,
            correctEn: language.family,
            distractors: familyDistractors,
          ),
          _question(
            id: '$lessonId:script',
            promptVi: 'Chữ viết đang theo dõi cho ${language.nameVi} là gì?',
            promptEn: 'Which writing system is tracked for ${language.nameEn}?',
            correctVi: scriptLabel,
            correctEn: scriptLabel,
            distractors: scriptDistractors,
          ),
          _question(
            id: '$lessonId:region',
            promptVi: '${people.nameVi} sinh sống chủ yếu ở đâu?',
            promptEn: 'Where do the ${people.nameEn} mainly live?',
            correctVi: people.regionVi,
            correctEn: people.regionEn,
            distractors: regionDistractors,
          ),
        ],
      ),
    );
  }
  return lessons;
}

QuizQuestion _question({
  required String id,
  required String promptVi,
  required String promptEn,
  required String correctVi,
  required String correctEn,
  required List<String> distractors,
}) {
  final options = _rotate([correctVi, ...distractors.take(3)], id);
  return QuizQuestion(
    id: id,
    promptVi: promptVi,
    promptEn: promptEn,
    choices: [
      for (final label in options)
        QuizChoice(
          id: label == correctVi ? '$id:ok' : '$id:x${options.indexOf(label)}',
          textVi: label,
          textEn: label == correctVi ? correctEn : label,
        ),
    ],
  );
}

List<String> _rotate(List<String> options, String key) {
  if (options.isEmpty) return options;
  final shift = key.codeUnits.fold<int>(0, (sum, unit) => sum + unit) % options.length;
  return [...options.sublist(shift), ...options.sublist(0, shift)];
}

/// Builds the same snapshot from Supabase tables without copying answer keys.
SyncSnapshot snapshotFromTables({
  required List<Map<String, dynamic>> languages,
  required List<Map<String, dynamic>> groups,
  required List<Map<String, dynamic>> heritage,
  required List<Map<String, dynamic>> lessons,
  required List<Map<String, dynamic>> questions,
  required List<Map<String, dynamic>> choices,
  required List<Map<String, dynamic>> contributions,
}) {
  final slugByGroup = {for (final group in groups) group['id']: group['slug']};
  final safeChoices = choices
      .map(
        (row) => {
          'id': row['id'],
          'question_id': row['question_id'],
          'text_vi': row['text_vi'],
          'text_en': row['text_en'],
        },
      )
      .toList();
  final lessonMaps = lessons.map((lesson) {
    final lessonQuestions = questions.where((row) => row['lesson_id'] == lesson['id']).map((question) {
      final questionChoices = safeChoices.where((row) => row['question_id'] == question['id']).map((row) {
        return {'id': row['id'], 'text_vi': row['text_vi'], 'text_en': row['text_en']};
      }).toList();
      return {
        'id': question['id'],
        'prompt_vi': question['prompt_vi'],
        'prompt_en': question['prompt_en'],
        'choices': questionChoices,
      };
    }).toList();
    return {...lesson, 'phrases': <Map<String, dynamic>>[], 'questions': lessonQuestions};
  }).toList();

  final parsedLanguages = languages.map((row) => Language.fromJson(_map(row))).toList();
  final languageByCode = {for (final language in parsedLanguages) language.code: language};
  final peoples = groups.map((row) {
    final data = _map(row);
    data['family'] = languageByCode[data['language_code']]?.family ?? data['family'] ?? '';
    return People.fromJson(data);
  }).toList();

  final remoteLessons = lessonMaps.map((row) => Lesson.fromJson(_map(row))).toList();
  final bundled = lessonsFromCatalogMeta(peoples: peoples, languageByCode: languageByCode);
  final mergedLessons = remoteLessons.isNotEmpty ? remoteLessons : bundled;

  return SyncSnapshot(
    languages: parsedLanguages,
    peoples: peoples,
    heritage: heritage
        .map(
          (row) => HeritageItem.fromJson({
            ...row,
            'group_slug': slugByGroup[row['group_id']],
          }),
        )
        .toList(),
    lessons: mergedLessons,
  );
}

Map<String, dynamic> _map(Object? row) => Map<String, dynamic>.from(row as Map);
