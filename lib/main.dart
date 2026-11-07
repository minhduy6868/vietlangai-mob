import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/catalog_mapping.dart';
import 'data/local_store.dart';
import 'data/open_box.dart';
import 'data/services/preference_store.dart';
import 'data/wiring.dart';
import 'ui/app_providers.dart';
import 'ui/core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
  }
  final store = LocalStore(await openAppBox());
  if (!await store.hasCatalog()) {
    final raw = await rootBundle.loadString('assets/catalog.json');
    await store.replaceSnapshot(snapshotFromBundledCatalog(jsonDecode(raw) as Map<String, dynamic>));
  }
  final preferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      retry: (count, error) => null,
      overrides: [
        localStoreProvider.overrideWithValue(store),
        preferenceStoreProvider.overrideWithValue(SharedPreferenceStore(preferences)),
        syncRunnerProvider.overrideWith((ref) => ref.watch(syncUseCaseProvider).run),
      ],
      child: const NgonSacVietApp(),
    ),
  );
}
