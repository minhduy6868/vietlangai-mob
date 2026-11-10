import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_store.dart';
import 'services/preference_store.dart';

final localStoreProvider = Provider<LocalStore>((ref) => throw StateError('LocalStore is missing'));

final preferenceStoreProvider = Provider<PreferenceStore>(
  (ref) => throw StateError('PreferenceStore is missing'),
);
