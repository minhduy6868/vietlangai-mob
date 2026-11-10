import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../data/wiring.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

class LearnListView extends ConsumerStatefulWidget {
  const LearnListView({super.key});

  @override
  ConsumerState<LearnListView> createState() => _LearnListViewState();
}

class _LearnListViewState extends ConsumerState<LearnListView> {
  int _currentCardIndex = 0;
  bool _isRecording = false;
  int? _accuracyScore;

  final List<Map<String, dynamic>> _flashcards = [
    {
      'word': 'Bươn',
      'phonetic': '/bɯən/',
      'meaning': 'Tháng',
      'example': 'Bươn nảy slí slíp bươn chiêng',
      'exampleVi': 'Tháng này là tháng Giêng',
      'course': 'Tiếng Tày Cơ Bản',
    },
    {
      'word': 'Kơi nyơh',
      'phonetic': '/kəːj ɲəːh/',
      'meaning': 'Chào hỏi / Khỏe mạnh',
      'example': 'Kơi nyơh lĭ oas?',
      'exampleVi': 'Bạn có khỏe không?',
      'course': 'Tiếng M\'nông Giao Tiếp',
    },
    {
      'word': 'Hơmei',
      'phonetic': '/həːmej/',
      'meaning': 'Cơm / Bữa ăn',
      'example': 'Bơng hơmei kơ',
      'exampleVi': 'Mời ăn cơm',
      'course': 'Tiếng Ê Đê Cơ Bản',
    },
  ];

  final List<Map<String, dynamic>> _curriculum = [
    {
      'id': 'lesson-1',
      'title': 'Lời chào buôn làng',
      'desc': 'Các câu chào hỏi trang trọng và thân mật',
      'status': 'completed', // completed, in_progress, locked
      'badge': 'Đã hoàn thành',
    },
    {
      'id': 'lesson-2',
      'title': 'Các chữ cái & âm tiết nâng cao',
      'desc': 'Quy tắc thanh điệu và biến âm đặc trưng',
      'status': 'in_progress',
      'badge': 'Đang học',
    },
    {
      'id': 'lesson-3',
      'title': 'Ẩm thực & Hương vị Khau Nhục',
      'desc': 'Từ vựng các món ăn truyền thống vùng cao',
      'status': 'locked',
      'badge': 'Khóa',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lessonsAsync = ref.watch(lessonsProvider);

    final currentCard = _flashcards[_currentCardIndex];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. Course Progress Header Card
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AC0D).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'LỚP CƠ BẢN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC07D16),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Tiến độ 30%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                currentCard['course'],
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.30,
                  minHeight: 6,
                  backgroundColor: isDark ? Colors.white12 : const Color(0xFFE2D6CB),
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 2. Flashcard Interactive Vocab Study Card (Figma Style)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                // Cultural illustration placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF382320), const Color(0xFF1E1E22)]
                            : [const Color(0xFF8B261E), const Color(0xFFD4AC0D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 56,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Từ vựng hôm nay',
                              style: TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Ethnic Word
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentCard['word'],
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Nghe phát âm',
                      onPressed: () => _show('Phát âm: ${currentCard['word']}'),
                      icon: Icon(
                        Icons.volume_up_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${currentCard['phonetic']}  •  ${currentCard['meaning']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF19191D) : const Color(0xFFF9F7F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2C2C32) : const Color(0xFFEBE5DF),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '“${currentCard['example']}”',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '(${currentCard['exampleVi']})',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Card Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _currentCardIndex > 0
                          ? () => setState(() {
                                _currentCardIndex--;
                                _accuracyScore = null;
                              })
                          : null,
                      icon: const Icon(Icons.arrow_back_rounded, size: 16),
                      label: const Text('Trước'),
                    ),
                    Text(
                      '${_currentCardIndex + 1} / ${_flashcards.length}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    TextButton.icon(
                      onPressed: _currentCardIndex < _flashcards.length - 1
                          ? () => setState(() {
                                _currentCardIndex++;
                                _accuracyScore = null;
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
        const SizedBox(height: 14),

        // 3. Pronunciation Practice Mic Section (Figma Style)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Luyện phát âm AI',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nhấn giữ nút micro để đọc từ "${currentCard['word']}"',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 16),

                // Big Mic Button
                GestureDetector(
                  onTapDown: (_) => setState(() => _isRecording = true),
                  onTapUp: (_) => _finishRecording(),
                  onTapCancel: () => setState(() => _isRecording = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isRecording ? 76 : 64,
                    height: _isRecording ? 76 : 64,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: _isRecording ? 0.5 : 0.25),
                          blurRadius: _isRecording ? 20 : 10,
                          spreadRadius: _isRecording ? 4 : 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                      color: Colors.white,
                      size: _isRecording ? 34 : 28,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (_isRecording)
                  const Text(
                    'Đang thu âm giọng đọc...',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  )
                else if (_accuracyScore != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Độ chính xác: $_accuracyScore% — Phát âm rất chuẩn!',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'Giữ để đọc • Thả để chấm điểm',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // 4. Section: Lộ trình bài học tiếp theo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lộ trình tiếp theo',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              '3 bài học',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        for (final item in _curriculum)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item['status'] == 'completed'
                      ? Colors.green.withValues(alpha: 0.15)
                      : (item['status'] == 'in_progress'
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.15)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item['status'] == 'completed'
                      ? Icons.check_rounded
                      : (item['status'] == 'in_progress'
                          ? Icons.play_arrow_rounded
                          : Icons.lock_outline_rounded),
                  size: 18,
                  color: item['status'] == 'completed'
                      ? Colors.green
                      : (item['status'] == 'in_progress'
                          ? theme.colorScheme.primary
                          : Colors.grey),
                ),
              ),
              title: Text(
                item['title'],
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              subtitle: Text(
                item['desc'],
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item['status'] == 'completed'
                      ? Colors.green.withValues(alpha: 0.12)
                      : (item['status'] == 'in_progress'
                          ? const Color(0xFFD4AC0D).withValues(alpha: 0.18)
                          : Colors.grey.withValues(alpha: 0.12)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item['badge'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: item['status'] == 'completed'
                        ? Colors.green
                        : (item['status'] == 'in_progress'
                            ? const Color(0xFFC07D16)
                            : Colors.grey),
                  ),
                ),
              ),
              onTap: () {
                lessonsAsync.whenData((rows) {
                  if (rows.isNotEmpty) {
                    context.go('/learn/${rows.first.id}');
                  } else {
                    _show('Đang mở bài: ${item['title']}');
                  }
                });
              },
            ),
          ),
      ],
    );
  }

  void _finishRecording() {
    setState(() {
      _isRecording = false;
      _accuracyScore = 88;
    });
    _show('Hoàn thành thu âm! Độ chính xác đạt 88%');
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
        title: const Text('Kiểm tra bài học'),
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
              const SizedBox(height: 16),
              Text(
                'Câu hỏi trắc nghiệm',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _loading ? null : () => _submit(l10n),
                child: Text(l10n.submit),
              ),
              if (_score != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Center(
                      child: Text(
                        'Kết quả: $_score',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
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
      final res = await api.guard(
        api.submitQuiz(widget.lessonId, _answers),
      );
      if (mounted) {
        setState(() {
          _score = l10n.scoreLabel(res.score, res.total);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _score = '${_answers.length} câu đã trả lời (chế độ ngoại tuyến)';
          _loading = false;
        });
      }
    }
  }
}
