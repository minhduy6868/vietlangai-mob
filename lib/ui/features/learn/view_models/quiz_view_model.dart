import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/wiring.dart';
import '../../../../domain/models/models.dart';

class QuizSubmitResult {
  const QuizSubmitResult({required this.scoreLabel, this.offline = false});

  final String scoreLabel;
  final bool offline;
}

class QuizViewModel extends Notifier<void> {
  @override
  void build() {}

  Future<QuizSubmitResult> submit({
    required String lessonId,
    required Lesson lesson,
    required Map<String, String> answers,
    required String Function(int score, int total) scoreLabel,
  }) async {
    final api = ref.read(apiClientProvider);
    try {
      final res = await api.guard(api.submitQuiz(lessonId, answers));
      return QuizSubmitResult(scoreLabel: scoreLabel(res.score, res.total));
    } catch (_) {
      // Offline scoring for bundled meta quizzes (correct choice ids end with :ok).
      var score = 0;
      for (final question in lesson.questions) {
        final selected = answers[question.id];
        if (selected != null && selected.endsWith(':ok')) score += 1;
      }
      return QuizSubmitResult(
        scoreLabel: '${scoreLabel(score, lesson.questions.length)} · offline',
        offline: true,
      );
    }
  }
}

final quizViewModelProvider = NotifierProvider<QuizViewModel, void>(
  QuizViewModel.new,
);
