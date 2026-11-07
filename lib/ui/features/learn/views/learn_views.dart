import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/wiring.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

class LearnListView extends ConsumerWidget {
  const LearnListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final lessons = ref.watch(lessonsProvider);
    return lessons.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (rows) {
        if (rows.isEmpty) {
          return Center(
            child: Text(l10n.emptyLessons, textAlign: TextAlign.center),
          );
        }
        return ListView(
          children: [
            for (final lesson in rows)
              ListTile(
                title: Text(locale == 'vi' ? lesson.titleVi : lesson.titleEn),
                subtitle: Text(lesson.languageCode),
                onTap: () => context.go('/learn/${lesson.id}'),
              ),
          ],
        );
      },
    );
  }
}

class QuizView extends ConsumerStatefulWidget {
  const QuizView({required this.lessonId, super.key});

  final String lessonId;

  @override
  ConsumerState<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends ConsumerState<QuizView> {
  final Map<String, String> _answers = {};
  String? _score;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final lesson = ref.watch(lessonProvider(widget.lessonId));
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: lesson.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (row) {
          if (row == null) return Center(child: Text(l10n.emptyLessons));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(onPressed: () => context.pop()),
              ),
              Text(
                locale == 'vi' ? row.titleVi : row.titleEn,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(locale == 'vi' ? row.summaryVi : row.summaryEn),
              const SizedBox(height: 8),
              Text(l10n.phraseNote),
              const SizedBox(height: 16),
              for (final question in row.questions) ...[
                Text(locale == 'vi' ? question.promptVi : question.promptEn),
                for (final choice in question.choices)
                  RadioListTile<String>(
                    value: choice.id,
                    groupValue: _answers[question.id],
                    title: Text(locale == 'vi' ? choice.textVi : choice.textEn),
                    onChanged: (value) =>
                        setState(() => _answers[question.id] = value!),
                  ),
              ],
              FilledButton(
                onPressed: _loading ? null : () => _submit(l10n),
                child: Text(l10n.submit),
              ),
              if (_score != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_score!),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submit(AppLocalizations l10n) async {
    setState(() => _loading = true);
    final api = ref.read(apiClientProvider);
    try {
      final score = await api.guard(api.submitQuiz(widget.lessonId, _answers));
      setState(() => _score = l10n.scoreLabel(score.score, score.total));
    } catch (error) {
      setState(() => _score = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
