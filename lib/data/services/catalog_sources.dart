import '../../domain/models/models.dart';
import '../../domain/sync_use_case.dart';
import '../catalog_mapping.dart';
import 'api_client.dart';

abstract class TableReader {
  Future<List<Map<String, dynamic>>> select(String table);
}

class ApiCatalogSource implements CatalogSource {
  ApiCatalogSource(this._api);

  final ApiClient _api;

  @override
  Future<SyncSnapshot> pull() => _api.guard(_api.pullCatalog());
}

class ApiContributionSink implements ContributionSink {
  ApiContributionSink(this._api);

  final ApiClient _api;

  @override
  Future<List<Contribution>> push(List<Contribution> pending) {
    return _api.guard(_api.pushContributions(pending));
  }
}

class SupabaseCatalogSource implements CatalogSource {
  SupabaseCatalogSource(this._tables);

  final TableReader _tables;

  @override
  Future<SyncSnapshot> pull() async {
    return snapshotFromTables(
      languages: await _tables.select('languages'),
      groups: await _tables.select('ethnic_groups'),
      heritage: await _tables.select('heritage_items'),
      lessons: await _tables.select('lessons'),
      questions: await _tables.select('quiz_questions'),
      choices: await _tables.select('quiz_choices_public'),
      contributions: const [],
    );
  }
}
