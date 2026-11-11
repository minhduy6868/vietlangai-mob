import 'models/models.dart';

/// Ethnic languages first (by evaluation tier), then Vietnamese, then English.
List<Language> sortedForTranslate(List<Language> rows) {
  final copy = [...rows];
  copy.sort((a, b) {
    final rank = _rank(a).compareTo(_rank(b));
    if (rank != 0) return rank;
    final tier = a.evaluationTier.compareTo(b.evaluationTier);
    if (tier != 0) return tier;
    final script = _scriptRank(a).compareTo(_scriptRank(b));
    if (script != 0) return script;
    return a.code.compareTo(b.code);
  });
  return copy;
}

int _rank(Language row) {
  if (row.role == 'ethnic') return 0;
  if (row.code == 'vi') return 1;
  return 2;
}

int _scriptRank(Language row) => row.script == 'Latn' ? 0 : 1;

Language? firstEthnic(List<Language> rows) {
  final ordered = sortedForTranslate(rows);
  for (final row in ordered) {
    if (row.role == 'ethnic') return row;
  }
  return ordered.isEmpty ? null : ordered.first;
}

Language? vietnamese(List<Language> rows) {
  for (final row in rows) {
    if (row.code == 'vi') return row;
  }
  return null;
}

String displayName(Language row) => row.nameVi;
