import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../data/wiring.dart';
import '../../../../domain/language_order.dart';
import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

class LearnListView extends ConsumerStatefulWidget {
  const LearnListView({super.key});

  @override
  ConsumerState<LearnListView> createState() => _LearnListViewState();
}

class _LearnListViewState extends ConsumerState<LearnListView> {
  int _currentCardIndex = 0;

  List<Map<String, String>> _cardsFrom(List<Lesson> lessons) {
    // Only reviewer-approved phrases — never invent ethnic sentences.
    final cards = <Map<String, String>>[];
    for (final lesson in lessons) {
      for (final phrase in lesson.phrases) {
        cards.add({
          'word': phrase.nativeText,
          'meaning': phrase.viText,
          'course': lesson.titleVi,
          'lessonId': lesson.id,
        });
      }
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lessonsAsync = ref.watch(lessonsProvider);
    final languages = ref.watch(languagesProvider).asData?.value ?? const <Language>[];
    final names = {for (final language in languages) language.code: displayName(language)};

    return lessonsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (lessons) {
        if (lessons.isEmpty) {
          return Center(child: Text(l10n.emptyLessons, textAlign: TextAlign.center));
        }
        final cards = _cardsFrom(lessons);
        final card = cards.isEmpty ? null : cards[_currentCardIndex.clamp(0, cards.length - 1)];

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF241C1A) : const Color(0xFFFBF4ED),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF3E2D2A) : const Color(0xFFECD8CA),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tabLearn,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.phraseNote,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (card == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(l10n.phraseNote),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        card['course']!,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        card['word']!,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.phraseMeaningVi}: ${card['meaning']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: _currentCardIndex > 0
                                ? () => setState(() => _currentCardIndex--)
                                : null,
                            icon: const Icon(Icons.arrow_back_rounded, size: 16),
                            label: const Text('Trước'),
                          ),
                          Text('${_currentCardIndex + 1} / ${cards.length}'),
                          TextButton.icon(
                            onPressed: _currentCardIndex < cards.length - 1
                                ? () => setState(() => _currentCardIndex++)
                                : null,
                            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                            label: const Text('Tiếp theo'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 18),
            Text(
              'Lộ trình bài học',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            for (final lesson in lessons)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    lesson.titleVi,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: Text(
                    names[lesson.languageCode] ?? lesson.languageCode,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  trailing: Text('${lesson.phrases.length} câu mẫu'),
                  onTap: () => context.go('/learn/${lesson.id}'),
                ),
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
    final theme = Theme.of(context);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final lesson = ref.watch(lessonProvider(widget.lessonId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quiz),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: lesson.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (row) {
          if (row == null) return Center(child: Text(l10n.emptyLessons));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale == 'vi' ? row.titleVi : row.titleEn,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        locale == 'vi' ? row.summaryVi : row.summaryEn,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (row.phrases.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.approvedPhrases,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                for (final phrase in row.phrases)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(phrase.nativeText),
                      subtitle: Text('${l10n.phraseMeaningVi}: ${phrase.viText}'),
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              Text(
                l10n.phraseNote,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < row.questions.length; i++) ...[
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Câu ${i + 1}: ${locale == 'vi' ? row.questions[i].promptVi : row.questions[i].promptEn}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        for (final choice in row.questions[i].choices)
                          RadioListTile<String>(
                            value: choice.id,
                            groupValue: _answers[row.questions[i].id],
                            title: Text(
                              locale == 'vi' ? choice.textVi : choice.textEn,
                              style: const TextStyle(fontSize: 13),
                            ),
                            onChanged: (value) =>
                                setState(() => _answers[row.questions[i].id] = value!),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              FilledButton(
                onPressed: _loading ? null : () => _submit(l10n),
                child: Text(l10n.submit),
              ),
              if (_score != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(_score!, style: const TextStyle(fontWeight: FontWeight.w800)),
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
      final res = await api.guard(api.submitQuiz(widget.lessonId, _answers));
      if (mounted) {
        setState(() {
          _score = l10n.scoreLabel(res.score, res.total);
          _loading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _score = error.toString();
          _loading = false;
        });
      }
    }
  }
}
