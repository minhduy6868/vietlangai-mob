import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/catalog_mapping.dart';
import 'data/local_store.dart';
import 'data/open_box.dart';
import 'data/session_profile.dart';
import 'data/services/preference_store.dart';
import 'data/wiring.dart';
import 'ui/app_providers.dart';
import 'ui/core/app.dart';
import 'ui/core/splash_view.dart';

const _catalogBundleVersion = '2-lessons-meta';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
  }
  final store = LocalStore(await openAppBox());
  final raw = await rootBundle.loadString('assets/catalog.json');
  final bundled = snapshotFromBundledCatalog(jsonDecode(raw) as Map<String, dynamic>);
  final needsCatalog = !await store.hasCatalog();
  final needsLessonBump = (await store.catalogVersion()) != _catalogBundleVersion;
  if (needsCatalog) {
    await store.replaceSnapshot(bundled);
  } else if (needsLessonBump) {
    await store.replaceLessons(bundled.lessons);
  }
  await store.setCatalogVersion(_catalogBundleVersion);
  final preferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      retry: (count, error) => null,
      overrides: [
        localStoreProvider.overrideWithValue(store),
        preferenceStoreProvider.overrideWithValue(SharedPreferenceStore(preferences)),
        sessionProfileStoreProvider.overrideWithValue(SessionProfileStore(preferences)),
        syncRunnerProvider.overrideWith((ref) => ref.watch(syncUseCaseProvider).run),
      ],
      child: const _BootstrapApp(),
    ),
  );
}

class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp();

  @override
  State<_BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashView(),
      );
    }
    return const NgonSacVietApp();
  }
}
