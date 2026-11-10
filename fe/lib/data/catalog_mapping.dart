import '../domain/models/models.dart';

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
  return SyncSnapshot(languages: languages, peoples: peoples, heritage: heritage, lessons: const []);
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
  return SyncSnapshot.fromJson({
    'languages': languages,
    'peoples': groups,
    'heritage': heritage
        .map(
          (row) => {
            ...row,
            'group_slug': slugByGroup[row['group_id']],
          },
        )
        .toList(),
    'lessons': lessonMaps,
    'approved_contributions': contributions.where((row) => row['status'] == 'approved').toList(),
  });
}

Map<String, dynamic> _map(Object? row) => Map<String, dynamic>.from(row as Map);
