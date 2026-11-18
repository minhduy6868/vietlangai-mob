import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/local_store.dart';
import '../../../../data/services/api_client.dart';
import '../../../../data/wiring.dart';
import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';

class TranslateUiState {
  const TranslateUiState({
    this.loading = false,
    this.result,
    this.error,
    this.pronunciation,
    this.culturalNote,
    this.fromGlossary = false,
  });

  final bool loading;
  final TranslationResult? result;
  final String? error;
  final String? pronunciation;
  final String? culturalNote;
  final bool fromGlossary;

  TranslateUiState copyWith({
    bool? loading,
    TranslationResult? result,
    String? error,
    String? pronunciation,
    String? culturalNote,
    bool? fromGlossary,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return TranslateUiState(
      loading: loading ?? this.loading,
      result: clearResult ? result : result ?? this.result,
      error: clearError ? error : error ?? this.error,
      pronunciation: pronunciation ?? this.pronunciation,
      culturalNote: culturalNote ?? this.culturalNote,
      fromGlossary: fromGlossary ?? this.fromGlossary,
    );
  }
}

class TranslateViewModel extends Notifier<TranslateUiState> {
  @override
  TranslateUiState build() => const TranslateUiState();

  Future<void> translate(String text, String source, String target) async {
    if (text.trim().isEmpty) return;
    state = state.copyWith(
      loading: true,
      clearError: true,
      clearResult: true,
      pronunciation: null,
      culturalNote: null,
      fromGlossary: false,
    );
    final store = ref.read(localStoreProvider);
    final api = ref.read(apiClientProvider);

    try {
      final result = await api.guard(
        api.translateText(text: text, sourceLang: source, targetLang: target),
      );
      await _persistHistory(
        store,
        sourceText: text,
        targetText: result.text,
        from: source,
        to: target,
        engine: result.engine,
      );
      state = state.copyWith(loading: false, result: result, fromGlossary: false);
    } on ApiException catch (error) {
      final recovered = await _tryGlossaryFallback(
        store,
        text: text,
        from: source,
        to: target,
        persistHistory: true,
      );
      if (recovered) return;
      state = state.copyWith(loading: false, error: error.message);
    } catch (error) {
      // Preserve prior behavior: generic errors recover via glossary without writing history.
      final recovered = await _tryGlossaryFallback(
        store,
        text: text,
        from: source,
        to: target,
        persistHistory: false,
      );
      if (recovered) return;
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<bool> _tryGlossaryFallback(
    LocalStore store, {
    required String text,
    required String from,
    required String to,
    required bool persistHistory,
  }) async {
    final hit = await store.glossaryLookup(text: text, from: from, to: to);
    if (hit == null) return false;
    final result = TranslationResult(
      text: hit.target,
      sourceLang: from,
      targetLang: to,
      route: '$from>$to',
      engine: 'glossary',
      warnings: const ['Tra từ offline từ cặp đã duyệt / lịch sử máy.'],
    );
    if (persistHistory) {
      await _persistHistory(
        store,
        sourceText: text,
        targetText: hit.target,
        from: from,
        to: to,
        engine: 'glossary',
      );
    }
    state = state.copyWith(loading: false, result: result, fromGlossary: true);
    return true;
  }

  Future<void> _persistHistory(
    LocalStore store, {
    required String sourceText,
    required String targetText,
    required String from,
    required String to,
    required String engine,
  }) {
    return store.addHistory(
      TranslationHistoryItem(
        id: const Uuid().v4(),
        source: sourceText.trim(),
        target: targetText.trim(),
        from: from,
        to: to,
        at: DateTime.now().toIso8601String(),
        engine: engine,
      ),
    );
  }
}

final translateViewModelProvider =
    NotifierProvider<TranslateViewModel, TranslateUiState>(
  TranslateViewModel.new,
);
