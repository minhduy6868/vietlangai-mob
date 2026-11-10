import '../data/local_store.dart';
import '../domain/models/models.dart';

class SyncReport {
  const SyncReport({required this.online, this.message});

  final bool online;
  final String? message;
}

abstract class CatalogSource {
  Future<SyncSnapshot> pull();
}

abstract class ContributionSink {
  Future<List<Contribution>> push(List<Contribution> pending);
}

class SyncUseCase {
  SyncUseCase({required this.local, required this.catalog, required this.contributions});

  final LocalStore local;
  final CatalogSource catalog;
  final ContributionSink contributions;

  Future<SyncReport> run() async {
    try {
      final snapshot = await catalog.pull();
      await local.replaceSnapshot(snapshot);
      final pending = await local.pendingContributions();
      if (pending.isNotEmpty) {
        final saved = await contributions.push(pending);
        await local.applyPushed(saved);
      }
      return const SyncReport(online: true);
    } catch (error) {
      return SyncReport(online: false, message: error.toString());
    }
  }
}
