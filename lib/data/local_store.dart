import '../domain/models/models.dart';
import 'document_box.dart';

class LocalStore {
  LocalStore(this._box);

  final DocumentBox _box;

  Future<bool> hasCatalog() async => (await _box.meta('has_catalog')) == '1';

  Future<void> replaceSnapshot(SyncSnapshot snapshot) async {
    await _replace('languages', snapshot.languages.map((row) => (row.code, row.toJson())));
    await _replace('peoples', snapshot.peoples.map((row) => (row.slug, row.toJson())));
    await _replace('heritage', snapshot.heritage.map((row) => (row.id, row.toJson())));
    await _replace('lessons', snapshot.lessons.map((row) => (row.id, row.toJson())));
    await _box.setMeta('has_catalog', '1');
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

  Future<void> _replace(String collection, Iterable<(String, Map<String, dynamic>)> rows) async {
    await _box.clear(collection);
    for (final (id, json) in rows) {
      await _box.put(collection, id, json);
    }
  }
}
