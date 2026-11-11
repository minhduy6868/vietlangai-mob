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

class _LearnListViewState extends ConsumerState<LearnListView> with SingleTickerProviderStateMixin {
  int _currentCardIndex = 0;
  bool _flipped = false;

  List<Map<String, String>> _cardsFrom(List<Lesson> lessons, List<Language> languages) {
    // Prefer reviewer-approved phrases — never invent ethnic sentences.
    final cards = <Map<String, String>>[];
    for (final lesson in lessons) {
      for (final phrase in lesson.phrases) {
        cards.add({
          'front': phrase.nativeText,
          'back': phrase.viText,
          'kind': 'phrase',
          'course': lesson.titleVi,
          'lessonId': lesson.id,
        });
      }
    }
    if (cards.isNotEmpty) return cards;

    // Fallback: knowledge cards from catalog meta (Vietnamese about the language).
    final byCode = {for (final language in languages) language.code: language};
    for (final lesson in lessons) {
      final language = byCode[lesson.languageCode];
      cards.add({
        'front': 'Họ ngôn ngữ?',
        'back': language?.family ?? '—',
        'kind': 'meta',
        'course': lesson.titleVi,
        'lessonId': lesson.id,
      });
      cards.add({
        'front': 'Chữ viết theo dõi?',
        'back': language?.orthography ?? '—',
        'kind': 'meta',
        'course': lesson.titleVi,
        'lessonId': lesson.id,
      });
      cards.add({
        'front': lesson.titleVi,
        'back': lesson.summaryVi,
        'kind': 'meta',
        'course': 'Giới thiệu',
        'lessonId': lesson.id,
      });
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
        final cards = _cardsFrom(lessons, languages);
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
                    cards.any((row) => row['kind'] == 'phrase')
                        ? l10n.phraseNote
                        : 'Thẻ kiến thức từ catalog: họ ngôn ngữ, chữ viết, vùng — không bịa câu dân tộc. Quiz chạy offline trên máy.',
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
              GestureDetector(
                onTap: () => setState(() => _flipped = !_flipped),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.45 : 0.28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        card['course']!,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _flipped ? 'Mặt sau · chạm để úp' : 'Mặt trước · chạm để lật',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: Text(
                          _flipped ? card['back']! : card['front']!,
                          key: ValueKey('${_currentCardIndex}_$_flipped'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: _flipped
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.primary,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: _currentCardIndex > 0
                                ? () => setState(() {
                                      _currentCardIndex--;
                                      _flipped = false;
                                    })
                                : null,
                            icon: const Icon(Icons.arrow_back_rounded, size: 16),
                            label: const Text('Trước'),
                          ),
                          Text('${_currentCardIndex + 1} / ${cards.length}'),
                          TextButton.icon(
                            onPressed: _currentCardIndex < cards.length - 1
                                ? () => setState(() {
                                      _currentCardIndex++;
                                      _flipped = false;
                                    })
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
                    '${names[lesson.languageCode] ?? lesson.languageCode} · ${lesson.questions.length} câu hỏi',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  trailing: Text(
                    lesson.phrases.isEmpty ? 'Kiến thức' : '${lesson.phrases.length} câu mẫu',
                    style: const TextStyle(fontSize: 11),
                  ),
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
                'Quiz kiến thức từ catalog. Chấm điểm offline nếu máy chủ chưa sẵn sàng.',
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
                onPressed: _loading ? null : () => _submit(l10n, row),
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

  Future<void> _submit(AppLocalizations l10n, Lesson row) async {
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
    } catch (_) {
      // Offline scoring for bundled meta quizzes (correct choice ids end with :ok).
      var score = 0;
      for (final question in row.questions) {
        final selected = _answers[question.id];
        if (selected != null && selected.endsWith(':ok')) score += 1;
      }
      if (mounted) {
        setState(() {
          _score = '${l10n.scoreLabel(score, row.questions.length)} · offline';
          _loading = false;
        });
      }
    }
  }
}
