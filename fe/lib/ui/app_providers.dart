import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../domain/models/models.dart';
import '../domain/sync_use_case.dart';

export '../data/providers.dart';

final languagesProvider = FutureProvider<List<Language>>((ref) {
  return ref.watch(localStoreProvider).languages();
});

final peoplesProvider = FutureProvider<List<People>>((ref) {
  return ref.watch(localStoreProvider).peoples();
});

final lessonsProvider = FutureProvider<List<Lesson>>((ref) {
  return ref.watch(localStoreProvider).lessons();
});

final contributionsProvider = FutureProvider<List<Contribution>>((ref) {
  return ref.watch(localStoreProvider).contributions();
});

final lessonProvider = FutureProvider.family<Lesson?, String>((ref, id) {
  return ref.watch(localStoreProvider).lesson(id);
});

final heritageProvider = FutureProvider.family<List<HeritageItem>, String>((ref, slug) {
  return ref.watch(localStoreProvider).heritageFor(slug);
});

final syncRunnerProvider = Provider<Future<SyncReport> Function()>((ref) {
  throw StateError('Sync runner is missing');
});
