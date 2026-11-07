import 'package:flutter_test/flutter_test.dart';
import 'package:ngon_sac_viet/data/catalog_mapping.dart';
import 'package:ngon_sac_viet/data/document_box.dart';
import 'package:ngon_sac_viet/data/local_store.dart';
import 'package:ngon_sac_viet/domain/models/models.dart';
import 'package:ngon_sac_viet/domain/recognize_text.dart';
import 'package:ngon_sac_viet/domain/sync_use_case.dart';

void main() {
  test('bundled catalog copies the language family onto the people record', () {
    final snapshot = snapshotFromBundledCatalog({
      'languages': [
        {
          'code': 'tyz',
          'iso639_3': 'tyz',
          'name_vi': 'Tiếng Tày',
          'name_en': 'Tay',
          'script': 'Latn',
          'family': 'Tai-Kadai',
          'role': 'ethnic',
          'evaluation_tier': 1,
          'orthography': 'Latin',
        },
      ],
      'peoples': [
        {
          'slug': 'tay',
          'language_code': 'tyz',
          'name_vi': 'Người Tày',
          'name_en': 'Tay people',
          'region_vi': 'Phía Bắc',
          'region_en': 'The north',
          'origin_vi': 'Tai',
          'origin_en': 'Tai',
        },
      ],
      'heritage': [
        {
          'slug': 'tay',
          'kind': 'article',
          'title_vi': 'Chữ',
          'title_en': 'Script',
          'body_vi': 'Latin',
          'body_en': 'Latin',
        },
      ],
    });
    expect(snapshot.peoples.single.family, 'Tai-Kadai');
    expect(snapshot.heritage.single.groupSlug, 'tay');
  });

  test('supabase rows do not keep the quiz answer key', () {
    final snapshot = snapshotFromTables(
      languages: const [],
      groups: const [],
      heritage: const [],
      lessons: const [
        {
          'id': 'lesson',
          'language_code': 'tyz',
          'title_vi': 'A',
          'title_en': 'A',
          'summary_vi': 'S',
          'summary_en': 'S',
          'level': 'basic',
        },
      ],
      questions: const [
        {'id': 'q', 'lesson_id': 'lesson', 'prompt_vi': 'P', 'prompt_en': 'P'},
      ],
      choices: const [
        {'id': 'c', 'question_id': 'q', 'text_vi': 'X', 'text_en': 'X', 'is_correct': true},
      ],
      contributions: const [],
    );
    expect(snapshot.lessons.single.questions.single.choices.single.textVi, 'X');
    expect(snapshot.lessons.single.toJson().toString().contains('is_correct'), isFalse);
  });

  test('sync keeps a local contribution when the server is offline', () async {
    final store = LocalStore(MemoryDocumentBox());
    await store.saveContribution(
      const Contribution(
        clientId: 'device-1',
        languageCode: 'tyz',
        sourceLang: 'tyz',
        targetLang: 'vi',
        sourceText: 'pair_a',
        targetText: 'xin chào',
      ),
    );
    final useCase = SyncUseCase(
      local: store,
      catalog: _BrokenCatalog(),
      contributions: _Sink(),
    );
    final report = await useCase.run();
    expect(report.online, isFalse);
    expect((await store.pendingContributions()).single.clientId, 'device-1');
  });

  test('sync uploads a pending contribution and stores the server id', () async {
    final store = LocalStore(MemoryDocumentBox());
    await store.saveContribution(
      const Contribution(
        clientId: 'device-1',
        languageCode: 'tyz',
        sourceLang: 'tyz',
        targetLang: 'vi',
        sourceText: 'pair_a',
        targetText: 'xin chào',
      ),
    );
    final useCase = SyncUseCase(local: store, catalog: _Catalog(), contributions: _Sink());
    final report = await useCase.run();
    expect(report.online, isTrue);
    expect(await store.pendingContributions(), isEmpty);
    expect((await store.contributions()).single.id, 'server-1');
  });

  test('on-device text recognition trims text and rejects an empty page', () async {
    final page = await const RecognizeTextUseCase(_Engine('  Xin chào  ')).call('photo.jpg');
    expect(page.text, 'Xin chào');
    expect(() => const RecognizeTextUseCase(_Engine('   ')).call('photo.jpg'), throwsA(isA<OcrEmptyException>()));
  });
}

class _Engine implements OcrEngine {
  const _Engine(this.text);

  final String text;

  @override
  Future<String> recognizePath(String path) async => text;
}

class _BrokenCatalog implements CatalogSource {
  @override
  Future<SyncSnapshot> pull() => throw Exception('offline');
}

class _Catalog implements CatalogSource {
  @override
  Future<SyncSnapshot> pull() async => const SyncSnapshot(languages: [], peoples: [], heritage: [], lessons: []);
}

class _Sink implements ContributionSink {
  @override
  Future<List<Contribution>> push(List<Contribution> pending) async {
    return [for (final row in pending) row.copyWith(id: 'server-1')];
  }
}
