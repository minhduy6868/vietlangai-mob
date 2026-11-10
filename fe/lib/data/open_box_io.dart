import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'document_box.dart';
import 'sqlite_document_box.dart';

Future<DocumentBox> openAppBox() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final directory = await getApplicationDocumentsDirectory();
  final database = await openDatabase(
    '${directory.path}${Platform.pathSeparator}ngon_sac_viet.db',
    version: 1,
  );
  await SqliteDocumentBox.migrate(database);
  return SqliteDocumentBox(database);
}
