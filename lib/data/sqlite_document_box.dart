import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'document_box.dart';

class SqliteDocumentBox implements DocumentBox {
  SqliteDocumentBox(this._db);

  final Database _db;

  static Future<void> migrate(Database db) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS documents (collection TEXT NOT NULL, id TEXT NOT NULL, payload TEXT NOT NULL, PRIMARY KEY (collection, id))',
    );
    await db.execute('CREATE TABLE IF NOT EXISTS meta (key TEXT PRIMARY KEY, value TEXT NOT NULL)');
  }

  @override
  Future<void> put(String collection, String id, Map<String, dynamic> json) {
    return _db.insert('documents', {
      'collection': collection,
      'id': id,
      'payload': jsonEncode(json),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<Map<String, dynamic>>> all(String collection) async {
    final rows = await _db.query('documents', where: 'collection = ?', whereArgs: [collection]);
    return rows.map((row) => jsonDecode(row['payload']! as String) as Map<String, dynamic>).toList();
  }

  @override
  Future<void> clear(String collection) {
    return _db.delete('documents', where: 'collection = ?', whereArgs: [collection]);
  }

  @override
  Future<void> setMeta(String key, String value) {
    return _db.insert('meta', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<String?> meta(String key) async {
    final rows = await _db.query('meta', where: 'key = ?', whereArgs: [key], limit: 1);
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }
}
