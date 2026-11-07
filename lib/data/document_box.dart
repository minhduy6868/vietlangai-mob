abstract class DocumentBox {
  Future<void> put(String collection, String id, Map<String, dynamic> json);
  Future<List<Map<String, dynamic>>> all(String collection);
  Future<void> clear(String collection);
  Future<void> setMeta(String key, String value);
  Future<String?> meta(String key);
}

class MemoryDocumentBox implements DocumentBox {
  final Map<String, Map<String, Map<String, dynamic>>> _rows = {};
  final Map<String, String> _meta = {};

  @override
  Future<void> put(String collection, String id, Map<String, dynamic> json) async {
    _rows.putIfAbsent(collection, () => {})[id] = json;
  }

  @override
  Future<List<Map<String, dynamic>>> all(String collection) async {
    return _rows[collection]?.values.toList() ?? [];
  }

  @override
  Future<void> clear(String collection) async {
    _rows.remove(collection);
  }

  @override
  Future<void> setMeta(String key, String value) async {
    _meta[key] = value;
  }

  @override
  Future<String?> meta(String key) async => _meta[key];
}
