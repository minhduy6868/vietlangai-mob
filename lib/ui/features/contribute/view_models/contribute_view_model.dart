import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';

class ContributeSaveInput {
  const ContributeSaveInput({
    required this.languageCode,
    required this.sourceText,
    required this.targetText,
    this.note,
  });

  final String languageCode;
  final String sourceText;
  final String targetText;
  final String? note;
}

class ContributeViewModel extends Notifier<void> {
  @override
  void build() {}

  Future<String?> savePending(ContributeSaveInput input) async {
    final language = input.languageCode.trim();
    final source = input.sourceText.trim();
    final target = input.targetText.trim();
    if (language.isEmpty || source.isEmpty || target.isEmpty) {
      return 'Vui lòng điền đầy đủ câu nguồn và câu đích';
    }
    final note = input.note?.trim();
    final row = Contribution(
      clientId: const Uuid().v4(),
      languageCode: language,
      sourceLang: language,
      targetLang: 'vi',
      sourceText: source,
      targetText: target,
      note: (note == null || note.isEmpty) ? null : note,
      status: 'pending',
    );
    await ref.read(localStoreProvider).saveContribution(row);
    ref.invalidate(contributionsProvider);
    return null;
  }
}

final contributeViewModelProvider = NotifierProvider<ContributeViewModel, void>(
  ContributeViewModel.new,
);
