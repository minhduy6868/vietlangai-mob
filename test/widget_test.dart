import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngon_sac_viet/data/document_box.dart';
import 'package:ngon_sac_viet/data/local_store.dart';
import 'package:ngon_sac_viet/data/services/preference_store.dart';
import 'package:ngon_sac_viet/data/session_profile.dart';
import 'package:ngon_sac_viet/domain/sync_use_case.dart';
import 'package:ngon_sac_viet/ui/app_providers.dart';
import 'package:ngon_sac_viet/ui/core/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app opens on translate tab for guests', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        retry: (count, error) => null,
        overrides: [
          localStoreProvider.overrideWithValue(LocalStore(MemoryDocumentBox())),
          preferenceStoreProvider.overrideWithValue(MemoryPreferenceStore()),
          sessionProfileStoreProvider.overrideWithValue(SessionProfileStore(prefs)),
          syncRunnerProvider.overrideWithValue(() async => const SyncReport(online: false)),
        ],
        child: const NgonSacVietApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dịch'), findsWidgets);
  });
}
