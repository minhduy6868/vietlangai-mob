import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngon_sac_viet/data/document_box.dart';
import 'package:ngon_sac_viet/data/local_store.dart';
import 'package:ngon_sac_viet/data/services/preference_store.dart';
import 'package:ngon_sac_viet/domain/sync_use_case.dart';
import 'package:ngon_sac_viet/ui/app_providers.dart';
import 'package:ngon_sac_viet/ui/core/app.dart';

void main() {
  testWidgets('shell opens on the translate tab', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: (count, error) => null,
        overrides: [
          localStoreProvider.overrideWithValue(LocalStore(MemoryDocumentBox())),
          preferenceStoreProvider.overrideWithValue(MemoryPreferenceStore()),
          syncRunnerProvider.overrideWithValue(() async => const SyncReport(online: false)),
        ],
        child: const NgonSacVietApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dịch'), findsWidgets);
    expect(find.text('Đóng góp'), findsOneWidget);
  });
}
