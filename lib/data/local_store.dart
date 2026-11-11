import '../domain/models/models.dart';
import 'document_box.dart';

class TranslationHistoryItem {
  const TranslationHistoryItem({
    required this.id,
    required this.source,
    required this.target,
    required this.from,
    required this.to,
    required this.at,
    this.engine,
  });

  final String id;
  final String source;
  final String target;
  final String from;
  final String to;
  final String at;
  final String? engine;

  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source,
        'target': target,
        'from': from,
        'to': to,
        'at': at,
        if (engine != null) 'engine': engine,
      };

  factory TranslationHistoryItem.fromJson(Map<String, dynamic> json) {
    return TranslationHistoryItem(
      id: json['id'] as String,
      source: json['source'] as String,
      target: json['target'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      at: json['at'] as String? ?? '',
      engine: json['engine'] as String?,
    );
  }
}

class LocalStore {
  LocalStore(this._box);

  final DocumentBox _box;

  Future<bool> hasCatalog() async => (await _box.meta('has_catalog')) == '1';

  Future<String?> catalogVersion() => _box.meta('catalog_version');

  Future<void> setCatalogVersion(String version) => _box.setMeta('catalog_version', version);

  Future<void> replaceSnapshot(SyncSnapshot snapshot) async {
    await _replace('languages', snapshot.languages.map((row) => (row.code, row.toJson())));
    await _replace('peoples', snapshot.peoples.map((row) => (row.slug, row.toJson())));
    await _replace('heritage', snapshot.heritage.map((row) => (row.id, row.toJson())));
    await _replace('lessons', snapshot.lessons.map((row) => (row.id, row.toJson())));
    await _box.setMeta('has_catalog', '1');
  }

  Future<void> replaceLessons(List<Lesson> lessons) async {
    await _replace('lessons', lessons.map((row) => (row.id, row.toJson())));
  }

  Future<List<Language>> languages() async =>
      (await _box.all('languages')).map(Language.fromJson).toList();

  Future<List<People>> peoples() async => (await _box.all('peoples')).map(People.fromJson).toList();

  Future<List<HeritageItem>> heritageFor(String slug) async {
    final rows = await _box.all('heritage');
    return rows.map(HeritageItem.fromJson).where((item) => item.groupSlug == slug).toList();
  }

  Future<List<Lesson>> lessons() async => (await _box.all('lessons')).map(Lesson.fromJson).toList();

  Future<Lesson?> lesson(String id) async {
    final rows = await lessons();
    for (final row in rows) {
      if (row.id == id) return row;
    }
    return null;
  }

  Future<void> saveContribution(Contribution contribution) {
    return _box.put('contributions', contribution.clientId, contribution.toJson());
  }

  Future<List<Contribution>> contributions() async =>
      (await _box.all('contributions')).map(Contribution.fromJson).toList();

  Future<List<Contribution>> pendingContributions() async {
    final rows = await contributions();
    return rows.where((row) => row.status == 'pending' && row.id == null).toList();
  }

  Future<void> applyPushed(List<Contribution> remote) async {
    for (final row in remote) {
      await saveContribution(row);
    }
  }

  Future<void> addHistory(TranslationHistoryItem item) async {
    await _box.put('history', item.id, item.toJson());
  }

  Future<List<TranslationHistoryItem>> history({int limit = 40}) async {
    final rows = (await _box.all('history')).map(TranslationHistoryItem.fromJson).toList();
    rows.sort((a, b) => b.at.compareTo(a.at));
    if (rows.length <= limit) return rows;
    return rows.sublist(0, limit);
  }

  Future<void> clearHistory() => _box.clear('history');

  /// Exact glossary hit from approved local contributions or past history.
  Future<TranslationHistoryItem?> glossaryLookup({
    required String text,
    required String from,
    required String to,
  }) async {
    final needle = text.trim().toLowerCase();
    if (needle.isEmpty) return null;

    final approved = (await contributions()).where((row) => row.status == 'approved');
    for (final row in approved) {
      if (row.sourceLang == from &&
          row.targetLang == to &&
          row.sourceText.trim().toLowerCase() == needle) {
        return TranslationHistoryItem(
          id: 'glossary:${row.clientId}',
          source: row.sourceText,
          target: row.targetText,
          from: from,
          to: to,
          at: DateTime.now().toIso8601String(),
          engine: 'glossary',
        );
      }
      if (row.sourceLang == to &&
          row.targetLang == from &&
          row.targetText.trim().toLowerCase() == needle) {
        return TranslationHistoryItem(
          id: 'glossary:${row.clientId}:rev',
          source: row.targetText,
          target: row.sourceText,
          from: from,
          to: to,
          at: DateTime.now().toIso8601String(),
          engine: 'glossary',
        );
      }
    }

    for (final row in await history()) {
      if (row.from == from && row.to == to && row.source.trim().toLowerCase() == needle) {
        return row;
      }
    }
    return null;
  }

  Future<void> _replace(String collection, Iterable<(String, Map<String, dynamic>)> rows) async {
    await _box.clear(collection);
    for (final (id, json) in rows) {
      await _box.put(collection, id, json);
    }
  }
}
