import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/local_store.dart';
import '../../../../data/services/ocr_engine.dart';
import '../../../../data/wiring.dart';
import '../../../../domain/language_order.dart';
import '../../../../domain/models/models.dart';
import '../../../../domain/recognize_text.dart';
import '../../../app_providers.dart';
import '../../../core/app_feedback.dart';
import '../../../core/speech_play_button.dart';
import '../../settings/view_models/settings_view_model.dart';
import '../view_models/translate_view_model.dart';

class TranslateView extends ConsumerStatefulWidget {
  const TranslateView({super.key});

  @override
  ConsumerState<TranslateView> createState() => _TranslateViewState();
}

class _TranslateViewState extends ConsumerState<TranslateView> {
  final _textController = TextEditingController();
  String? _sourceCode;
  String? _targetCode;
  int _selectedInputTab = 0; // 0: Bàn phím, 1: Âm thanh (ASR), 2: Quét ảnh (OCR)
  List<TranslationHistoryItem> _recentTranslations = [];

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHistory());
  }

  Future<void> _loadHistory() async {
    final rows = await ref.read(localStoreProvider).history(limit: 12);
    if (mounted) setState(() => _recentTranslations = rows);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceCode;
      _sourceCode = _targetCode;
      _targetCode = temp;
    });
  }

  Future<void> _runTranslate([String? overrideText]) async {
    final input = overrideText ?? _textController.text;
    if (input.trim().isEmpty || _sourceCode == null || _targetCode == null) {
      return;
    }
    if (overrideText != null) {
      _textController.text = overrideText;
    }
    await ref
        .read(translateViewModelProvider.notifier)
        .translate(input, _sourceCode!, _targetCode!);
    await _loadHistory();
  }

  String _capabilityTag(String code) {
    return switch (code) {
      'tyz' || 'rad' || 'khm' || 'zho' || 'lao' || 'en' => 'AI',
      'bdq' || 'mtq' || 'jra' => 'Kho câu',
      'cjm' || 'hmn' => 'Học liệu',
      _ => '',
    };
  }

  List<(String, String)> _samplePhrases(String source, String target) {
    final activeEthnic = source != 'vi' && source != 'en'
        ? source
        : (target != 'vi' && target != 'en' ? target : 'tyz');

    if (source == 'vi') {
      return switch (activeEthnic) {
        'khm' => const [
          ('Chào hỏi', 'Xin chào bà con buổi sáng tốt lành.'),
          ('Hỏi đường', 'Xin hỏi đường đến chợ ở đâu?'),
          ('Cảm ơn', 'Cảm ơn nhiều lắm.'),
        ],
        'zho' => const [
          ('Chào hỏi', 'Xin chào, rất vui được gặp bạn.'),
          ('Hỏi thăm', 'Gần đây có bệnh viện hoặc trạm y tế không?'),
          ('Cảm ơn', 'Cảm ơn sự giúp đỡ của bạn.'),
        ],
        'lao' => const [
          ('Chào hỏi', 'Chào buổi sáng mọi người.'),
          ('Sức khỏe', 'Hôm nay bạn có khỏe không?'),
          ('Cảm ơn', 'Cảm ơn nhiều lắm.'),
        ],
        'bdq' || 'mtq' || 'jra' => const [
          ('Mùa màng', 'Hôm nay trời mát mẻ, bà con cùng nhau lên rẫy.'),
          ('Chào hỏi', 'Xin chào'),
          ('Cảm ơn', 'Cám ơn nhiều lắm'),
          ('Buôn làng', 'Mọi người mặc trang phục truyền thống và đánh chiêng.'),
        ],
        'cjm' => const [
          ('Học liệu', 'Không'),
          ('Cảm ơn', 'Cảm ơn'),
        ],
        'hmn' => const [
          ('Cơ bản', 'Xin chào'),
          ('Cơ bản', 'Tạm biệt'),
        ],
        _ => const [
          ('Chào hỏi', 'Xin chào'),
          ('Cảm ơn', 'Cám ơn nhiều lắm'),
          ('Sinh hoạt', 'Hôm nay trời mát mẻ, bà con cùng nhau lên rẫy.'),
          ('Lễ hội', 'Mọi người mặc trang phục truyền thống và đánh chiêng.'),
        ],
      };
    }

    return switch (source) {
      'khm' => const [
        ('Lời chào Khmer', 'សួស្តី បងប្អូនទាំងអស់គ្នា'),
        ('Hỏi thăm', 'តើអ្នកសុខសប្បាយជាទេ?'),
      ],
      'zho' => const [
        ('Hỏi đường', '你好，请问最近的医院在哪里？'),
        ('Cảm ơn', '非常感谢你的帮助。'),
      ],
      'lao' => const [
        ('Lời chào Lào', 'ສະບາຍດີ ທຸກຄົນ ຕອນເຊົ້າ'),
        ('Cảm ơn', 'ຂອບໃຈຫຼາຍໆ'),
      ],
      'rad' => const [
        ('Câu Ê Đê', 'Brei drei bi mguô̆p čiăng ƀơ̆ng boh taŏ.'),
        ('Đời sống', 'Hôm nay thời tiết rất đẹp.'),
      ],
      'tyz' => const [
        ('Câu Tày', 'Ái chin mác rèo năm mạy.'),
        ('Hội thoại', 'Xin chào'),
      ],
      _ => const [
        ('Mẫu tiếng Việt', 'Chúc mọi người buổi sáng vui vẻ.'),
        ('Mẫu tiếng Anh', 'Hello, nice to meet you.'),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final languagesAsync = ref.watch(languagesProvider);
    final translation = ref.watch(translateViewModelProvider);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 960;

    return languagesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (rows) {
        if (rows.isEmpty) return Center(child: Text(l10n.emptyPeoples));

        _sourceCode ??= firstEthnic(rows)?.code ?? rows.first.code;
        _targetCode ??= vietnamese(rows)?.code ?? 'vi';

        final sourceLang = rows.firstWhere(
          (r) => r.code == _sourceCode,
          orElse: () => rows.first,
        );
        final targetLang = rows.firstWhere(
          (r) => r.code == _targetCode,
          orElse: () => rows.last,
        );

        final activeEthnicCode =
            sourceLang.code != 'vi' && sourceLang.code != 'en'
            ? sourceLang.code
            : (targetLang.code != 'vi' && targetLang.code != 'en'
                  ? targetLang.code
                  : 'tyz');
        final viToEthnic = sourceLang.code == 'vi';
        final quickLanguages = rows.where((r) => r.code != 'vi').toList();

        final matrixBar = Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Chọn nhanh ngôn ngữ đối chiếu với Tiếng Việt',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonalIcon(
                      onPressed: _swapLanguages,
                      icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                      label: Text(
                        viToEthnic ? 'Việt → Dân tộc' : 'Dân tộc → Việt',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final lang in quickLanguages) ...[
                        Builder(
                          builder: (context) {
                            final tag = _capabilityTag(lang.code);
                            final label = tag.isEmpty
                                ? displayName(lang)
                                : '${displayName(lang)} · $tag';
                            return ChoiceChip(
                              label: Text(
                                label,
                                style: const TextStyle(fontSize: 12.5),
                              ),
                              selected: activeEthnicCode == lang.code,
                              onSelected: (_) {
                                setState(() {
                                  if (viToEthnic) {
                                    _sourceCode = 'vi';
                                    _targetCode = lang.code;
                                  } else {
                                    _sourceCode = lang.code;
                                    _targetCode = 'vi';
                                  }
                                });
                                if (_textController.text.trim().isNotEmpty) {
                                  _runTranslate();
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                      ActionChip(
                        avatar: const Icon(Icons.tune_rounded, size: 16),
                        label: const Text('Cặp tuỳ chọn'),
                        onPressed: () => _showLanguageModal(
                          rows,
                          isSource: true,
                          locale: locale,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        final mainWorkspace = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildModeRow(l10n),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2E2E32)
                      : const Color(0xFFE6DFD5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _buildLanguageSelectorPill(
                              context,
                              label: displayName(sourceLang),
                              onTap: () => _showLanguageModal(
                                rows,
                                isSource: true,
                                locale: locale,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Đổi chiều',
                              onPressed: _swapLanguages,
                              icon: const Icon(Icons.swap_horiz_rounded),
                            ),
                            _buildLanguageSelectorPill(
                              context,
                              label: displayName(targetLang),
                              onTap: () => _showLanguageModal(
                                rows,
                                isSource: false,
                                locale: locale,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _textController,
                          minLines: 4,
                          maxLines: 7,
                          style: const TextStyle(fontSize: 16.5, height: 1.45),
                          decoration: InputDecoration(
                            hintText: l10n.enterText,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'Đọc tệp âm thanh (Whisper ASR)',
                              onPressed: () => _pickAudioForSpeech(l10n),
                              icon: const Icon(Icons.mic_none_rounded, size: 20),
                            ),
                            IconButton(
                              tooltip: 'Quét ảnh (OCR)',
                              onPressed: () => _readPhoto(l10n),
                              icon: const Icon(
                                Icons.document_scanner_outlined,
                                size: 20,
                              ),
                            ),
                            SpeechPlayButton(
                              enabled: _textController.text.trim().isNotEmpty,
                              tooltip:
                                  'Nghe phát âm đầu vào (${displayName(sourceLang)})',
                              buildUrl: () => ref
                                  .read(apiClientProvider)
                                  .ttsUrl(
                                    text: _textController.text,
                                    lang: sourceLang.code,
                                  ),
                            ),
                            if (_textController.text.isNotEmpty)
                              IconButton(
                                tooltip: 'Xóa',
                                onPressed: () =>
                                    setState(() => _textController.clear()),
                                icon: const Icon(Icons.close_rounded, size: 18),
                              ),
                            const Spacer(),
                            FilledButton.icon(
                              onPressed: translation.loading
                                  ? null
                                  : () => _runTranslate(),
                              icon: translation.loading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18,
                                    ),
                              label: Text(
                                translation.loading
                                    ? l10n.loading
                                    : l10n.translate,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (translation.error != null ||
                      translation.result != null) ...[
                    Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: _buildTargetPane(
                        context,
                        l10n: l10n,
                        targetLang: targetLang,
                        translation: translation,
                        embedded: true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildSamplesSection(context, sourceLang.code, targetLang.code),
          ],
        );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 24 : 16,
            vertical: 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  matrixBar,
                  const SizedBox(height: 14),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 65, child: mainWorkspace),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 35,
                          child: _buildHistorySection(context),
                        ),
                      ],
                    )
                  else ...[
                    mainWorkspace,
                    const SizedBox(height: 18),
                    _buildHistorySection(context),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeRow(AppLocalizations l10n) {
    return Row(
      children: [
        _buildModeChip(
          index: 0,
          icon: Icons.keyboard_outlined,
          label: 'Bàn phím',
          onTap: () => setState(() => _selectedInputTab = 0),
        ),
        const SizedBox(width: 8),
        _buildModeChip(
          index: 1,
          icon: Icons.mic_none_rounded,
          label: 'Âm thanh (ASR)',
          onTap: () {
            setState(() => _selectedInputTab = 1);
            _pickAudioForSpeech(l10n);
          },
        ),
        const SizedBox(width: 8),
        _buildModeChip(
          index: 2,
          icon: Icons.document_scanner_outlined,
          label: 'Quét ảnh (OCR)',
          onTap: () {
            setState(() => _selectedInputTab = 2);
            _readPhoto(l10n);
          },
        ),
      ],
    );
  }

  Widget _buildTargetPane(
    BuildContext context, {
    required AppLocalizations l10n,
    required Language targetLang,
    required TranslateUiState translation,
    bool embedded = false,
  }) {
    final theme = Theme.of(context);

    if (translation.error != null) {
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.error_outline_rounded,
            color: theme.colorScheme.error,
          ),
          title: Text(
            _friendlyError(l10n, translation.error!),
            style: TextStyle(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => showAppAlert(
            context,
            title: l10n.translate,
            message: _friendlyError(l10n, translation.error!),
            tone: AppFeedbackTone.error,
          ),
        ),
      );
    }

    if (translation.result == null) {
      return const SizedBox.shrink();
    }

    return _buildResultCard(
      context,
      translation: translation,
      targetCode: targetLang.code,
      targetName: displayName(targetLang),
      resultText: translation.result!.text,
      pronunciation: translation.pronunciation,
      culturalNote: translation.culturalNote,
      embedded: embedded,
    );
  }

  Widget _buildSamplesSection(
    BuildContext context,
    String sourceCode,
    String targetCode,
  ) {
    final theme = Theme.of(context);
    final samples = _samplePhrases(sourceCode, targetCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu thử nhanh',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final (label, sentence) in samples) ...[
                ActionChip(
                  avatar: Icon(
                    Icons.bolt_rounded,
                    size: 15,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    '$label: "$sentence"',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () => _runTranslate(sentence),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lịch sử tra cứu',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            if (_recentTranslations.isNotEmpty)
              TextButton(
                onPressed: () async {
                  await ref.read(localStoreProvider).clearHistory();
                  await _loadHistory();
                  _show('Đã xóa lịch sử máy', tone: AppFeedbackTone.success);
                },
                child: const Text('Xóa lịch sử', style: TextStyle(fontSize: 12)),
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (_recentTranslations.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Chưa có lịch sử. Mỗi lần dịch thành công sẽ lưu trên máy để tra lại offline.',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          )
        else
          for (final item in _recentTranslations)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _historyCard(context, item, isDark),
            ),
      ],
    );
  }

  Widget _historyCard(
    BuildContext context,
    TranslationHistoryItem item,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? const Color(0xFF2A2A2E) : const Color(0xFFEFEBE4),
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        title: Text(
          item.source,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          '${item.target} (${item.from} → ${item.to})'
          '${item.engine == null ? '' : ' · ${item.engine}'}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpeechPlayButton(
              tooltip: 'Nghe bản dịch (${item.to})',
              buildUrl: () => ref
                  .read(apiClientProvider)
                  .ttsUrl(text: item.target, lang: item.to),
            ),
            Icon(
              Icons.north_west_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
        onTap: () async {
          setState(() {
            _textController.text = item.source;
            _sourceCode = item.from;
            _targetCode = item.to;
          });
          await _runTranslate(item.source);
        },
      ),
    );
  }

  Widget _buildLanguageSelectorPill(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildModeChip({
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedInputTab == index;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(
                    alpha: isDark ? 0.3 : 0.12,
                  )
                : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : (isDark
                        ? const Color(0xFF2E2E32)
                        : const Color(0xFFEBE5DF)),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _friendlyError(AppLocalizations l10n, String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('model_not_ready') ||
        lower.contains('chưa có mô hình') ||
        lower.contains('no reviewed translator')) {
      return l10n.modelNotReady;
    }
    return raw;
  }

  Widget _buildResultCard(
    BuildContext context, {
    required TranslateUiState translation,
    required String targetCode,
    required String targetName,
    required String resultText,
    String? pronunciation,
    String? culturalNote,
    bool embedded = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final warnings = translation.result?.warnings ?? const <String>[];
    final engineName = translation.result?.engine ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF221715) : const Color(0xFFFFF7F6),
        borderRadius: BorderRadius.circular(embedded ? 12 : 16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: isDark ? 0.4 : 0.25,
          ),
          width: 1.2,
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
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  targetName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (engineName.isNotEmpty) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    engineName,
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ],
              const Spacer(),
              if (translation.fromGlossary)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'OFFLINE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Sao chép',
                icon: const Icon(Icons.copy_rounded, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: resultText));
                  _show('Đã sao chép kết quả', tone: AppFeedbackTone.success);
                },
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Chia sẻ',
                icon: const Icon(Icons.share_outlined, size: 18),
                onPressed: () => _shareTranslation(resultText),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText(
            resultText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18.5,
              height: 1.45,
              color: isDark
                  ? const Color(0xFFFFDAD6)
                  : const Color(0xFF410002),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SpeechPlayButton(
                compact: false,
                enabled: resultText.trim().isNotEmpty,
                label: 'Nghe phát âm ($targetName)',
                buildUrl: () => ref
                    .read(apiClientProvider)
                    .ttsUrl(text: resultText, lang: targetCode),
              ),
              SpeechPlayButton(
                compact: false,
                enabled: _textController.text.trim().isNotEmpty,
                label: 'Nghe câu gốc',
                buildUrl: () => ref
                    .read(apiClientProvider)
                    .ttsUrl(
                      text: _textController.text,
                      lang: _sourceCode ?? 'vi',
                    ),
              ),
            ],
          ),
          if (pronunciation != null && pronunciation.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Phiên âm: $pronunciation',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ],
          if (culturalNote != null && culturalNote.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B1B1E) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF333338)
                      : const Color(0xFFEBE5DF),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      culturalNote,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (warnings.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              warnings.join('\n'),
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLanguageModal(
    List<Language> rows, {
    required bool isSource,
    required String locale,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    isSource ? 'Chọn ngôn ngữ nguồn' : 'Chọn ngôn ngữ đích',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final item = rows[index];
                      final isSelected = isSource
                          ? item.code == _sourceCode
                          : item.code == _targetCode;
                      return ListTile(
                        title: Text(
                          item.role == 'auxiliary' || item.code == 'en'
                              ? '${displayName(item)} · ${AppLocalizations.of(context).viaVietnamese}'
                              : displayName(item),
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${item.code} · ${item.family}\n${item.orthography}',
                          style: const TextStyle(height: 1.35),
                        ),
                        isThreeLine: true,
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            if (isSource) {
                              _sourceCode = item.code;
                            } else {
                              _targetCode = item.code;
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAudioForSpeech(AppLocalizations l10n) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['wav', 'mp3', 'm4a', 'ogg', 'webm', 'flac', 'mp4'],
      withData: true,
    );
    if (result == null || result.files.isEmpty || !mounted) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      _show('Không đọc được tệp âm thanh.', tone: AppFeedbackTone.error);
      return;
    }
    _show('Đang nhận dạng giọng nói bằng Whisper ASR...');
    final res = await ref.read(translateViewModelProvider.notifier).translateSpeech(
          bytes: bytes,
          filename: file.name,
          source: _sourceCode ?? 'auto',
          target: _targetCode ?? 'vi',
        );
    if (!mounted) return;
    if (res == null) {
      final err = ref.read(translateViewModelProvider).error;
      _show(err ?? 'Không nhận dạng được âm thanh.', tone: AppFeedbackTone.error);
      return;
    }
    final recognized = (res.recognizedText ?? '').trim();
    if (recognized.isNotEmpty) {
      _textController.text = recognized;
    }
    await _loadHistory();
  }

  Future<void> _shareTranslation(String resultText) async {
    final source = _textController.text.trim();
    final payload = [
      if (source.isNotEmpty) source,
      resultText,
      '${_sourceCode ?? '?'} → ${_targetCode ?? '?'} · Ngôn Sắc Việt',
    ].join('\n');
    try {
      await SharePlus.instance.share(ShareParams(text: payload));
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: payload));
      if (mounted) {
        _show('Đã sao chép để chia sẻ', tone: AppFeedbackTone.success);
      }
    }
  }

  Future<void> _readPhoto(AppLocalizations l10n) async {
    if (kIsWeb) {
      final picked = await FilePicker.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (picked == null || picked.files.isEmpty || !mounted) return;
      final file = picked.files.single;
      final bytes = file.bytes;
      if (bytes == null || bytes.isEmpty) {
        _show(l10n.ocrEmpty, tone: AppFeedbackTone.error);
        return;
      }
      _show(l10n.ocrScanning);
      final result = await ref
          .read(translateViewModelProvider.notifier)
          .translateImage(
            bytes: bytes,
            filename: file.name,
            source: _sourceCode ?? 'auto',
            target: _targetCode ?? 'vi',
          );
      if (!mounted) return;
      if (result == null) {
        final err = ref.read(translateViewModelProvider).error;
        _show(err ?? l10n.ocrUnavailable, tone: AppFeedbackTone.error);
        return;
      }
      final recognized = (result.recognizedText ?? '').trim();
      if (recognized.isNotEmpty) _textController.text = recognized;
      await _loadHistory();
      return;
    }

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  l10n.ocrSourceTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.ocrCamera),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.ocrGallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (source == null || !mounted) return;
    await _scanImage(l10n, source);
  }

  Future<String?> _tryOnDeviceOcr(String path, List<int> bytes) async {
    if (kIsWeb) return null;
    final engine = MlKitHolder.engine;
    if (engine is UnavailableOcrEngine) return null;
    try {
      if (path.isNotEmpty) {
        final page = await RecognizeTextUseCase(engine).call(path);
        return page.text;
      }
      final page = await RecognizeTextUseCase(engine).fromBytes(bytes);
      return page.text;
    } on OcrEmptyException {
      return null;
    } on UnsupportedError {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _scanImage(AppLocalizations l10n, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? shot;
    try {
      shot = await picker.pickImage(
        source: source,
        imageQuality: 92,
        maxWidth: 2048,
        maxHeight: 2048,
        preferredCameraDevice: CameraDevice.rear,
      );
    } catch (_) {
      if (!mounted) return;
      _show(l10n.ocrUnavailable, tone: AppFeedbackTone.error);
      return;
    }
    if (shot == null || !mounted) return;

    _show(l10n.ocrScanning);
    final sourceLang = _sourceCode ?? 'auto';
    final targetLang = _targetCode ?? 'vi';
    final bytes = await shot.readAsBytes();
    if (bytes.isEmpty) {
      _show(l10n.ocrEmpty, tone: AppFeedbackTone.error);
      return;
    }

    final filename = _imageFilename(shot);
    final localText = await _tryOnDeviceOcr(shot.path, bytes);
    if (localText != null && localText.isNotEmpty) {
      _textController.text = localText;
      await ref
          .read(translateViewModelProvider.notifier)
          .translate(localText, sourceLang, targetLang);
      if (mounted) await _loadHistory();
      return;
    }

    final result = await ref
        .read(translateViewModelProvider.notifier)
        .translateImage(
          bytes: bytes,
          filename: filename,
          source: sourceLang,
          target: targetLang,
        );
    if (!mounted) return;
    if (result == null) {
      final err = ref.read(translateViewModelProvider).error;
      _show(err ?? l10n.ocrUnavailable, tone: AppFeedbackTone.error);
      return;
    }
    final recognized = (result.recognizedText ?? '').trim();
    if (recognized.isEmpty && result.text.trim().isEmpty) {
      _show(l10n.ocrEmpty, tone: AppFeedbackTone.error);
      return;
    }
    if (recognized.isNotEmpty) {
      _textController.text = recognized;
    }
    await _loadHistory();
  }

  String _imageFilename(XFile shot) {
    final name = shot.name.trim();
    if (name.isNotEmpty && name.contains('.')) return name;
    final path = shot.path;
    final slash = path.replaceAll('\\', '/').split('/').last;
    if (slash.contains('.')) return slash;
    final mime = shot.mimeType ?? '';
    if (mime.contains('png')) return 'scan.png';
    if (mime.contains('webp')) return 'scan.webp';
    return 'scan.jpg';
  }

  void _show(String message, {AppFeedbackTone tone = AppFeedbackTone.info}) {
    showAppSnack(context, message, tone: tone);
  }
}

class MlKitHolder {
  static final OcrEngine engine = createOcrEngine();
}
