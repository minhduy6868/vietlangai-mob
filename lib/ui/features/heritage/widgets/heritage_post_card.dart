import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../domain/models/heritage_post.dart';
import '../../../core/app_feedback.dart';
import '../../../core/speech_play_button.dart';
import 'heritage_video_player.dart';

class HeritagePostCard extends StatefulWidget {
  const HeritagePostCard({
    required this.post,
    required this.resolveUrl,
    this.peopleName,
    this.showStatus = false,
    this.canDelete = false,
    this.compactMediaFirst = false,
    this.onLike,
    this.onComment,
    this.onQuickComment,
    this.onTranslate,
    this.onDelete,
    this.footerExtra,
    super.key,
  });

  final HeritagePost post;
  final String Function(String? path) resolveUrl;
  final String? peopleName;
  final bool showStatus;
  final bool canDelete;
  final bool compactMediaFirst;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final Future<void> Function(String text)? onQuickComment;
  final Future<HeritagePostTranslation> Function(String targetLang)? onTranslate;
  final VoidCallback? onDelete;
  final Widget? footerExtra;

  @override
  State<HeritagePostCard> createState() => _HeritagePostCardState();
}

const _translateChoices = <(String, String)>[
  ('tyz', 'Tày'),
  ('rad', 'Ê Đê'),
  ('khm', 'Khmer'),
  ('zho', 'Hoa'),
  ('lao', 'Lào'),
  ('bdq', 'Ba Na'),
  ('mtq', 'Mường'),
  ('jra', 'Jrai'),
  ('vi', 'Việt'),
  ('en', 'English'),
];

class _HeritagePostCardState extends State<HeritagePostCard> {
  final _quickCtrl = TextEditingController();
  bool _sendingQuick = false;
  bool _showTranslateBar = false;
  bool _showQuickReply = false;
  String? _selectedLang;
  bool _translating = false;
  String? _translateError;
  final Map<String, HeritagePostTranslation> _translations = {};

  @override
  void dispose() {
    _quickCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleTranslate(String code) async {
    if (widget.onTranslate == null) return;
    if (_selectedLang == code && !_translating) {
      setState(() {
        _selectedLang = null;
        _translateError = null;
      });
      return;
    }
    setState(() {
      _selectedLang = code;
      _translateError = null;
    });
    if (_translations.containsKey(code)) return;

    setState(() => _translating = true);
    try {
      final result = await widget.onTranslate!(code);
      if (!mounted) return;
      setState(() {
        _translations[code] = result;
        _translating = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _translating = false;
        _translateError = error.toString();
      });
    }
  }

  String _langName(String code) {
    for (final (c, label) in _translateChoices) {
      if (c == code) return label;
    }
    return code.toUpperCase();
  }

  Future<void> _sendQuickComment() async {
    final text = _quickCtrl.text.trim();
    if (text.isEmpty || _sendingQuick || widget.onQuickComment == null) return;
    setState(() => _sendingQuick = true);
    try {
      await widget.onQuickComment!(text);
      if (mounted) _quickCtrl.clear();
    } finally {
      if (mounted) setState(() => _sendingQuick = false);
    }
  }

  void _openShareSheet(BuildContext context, HeritagePost post) {
    final fullText = [
      if (post.title.isNotEmpty) post.title,
      if (post.body.isNotEmpty) post.body,
      if (post.telegramUrl != null) post.telegramUrl!,
      'Kênh Di Sản · Ngôn Sắc Việt',
    ].join('\n');

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                child: Text(
                  'Chia sẻ bài di sản',
                  style: Theme.of(sheetCtx)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading: const CircleAvatar(
                  child: Icon(Icons.content_copy_rounded, size: 20),
                ),
                title: const Text('Sao chép nội dung & liên kết'),
                subtitle: const Text('Dán nhanh vào Facebook, Zalo, tin nhắn'),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: fullText));
                  if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                  if (context.mounted) {
                    showAppSnack(
                      context,
                      'Đã sao chép bài viết vào bộ nhớ tạm!',
                      tone: AppFeedbackTone.success,
                    );
                  }
                },
              ),
              if (post.telegramUrl != null)
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0x1F0088CC),
                    child: Icon(Icons.send_rounded, color: Color(0xFF0088CC), size: 20),
                  ),
                  title: const Text('Sao chép liên kết @ngonsacviet'),
                  subtitle: Text(
                    post.telegramUrl!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: post.telegramUrl!));
                    if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                    if (context.mounted) {
                      showAppSnack(
                        context,
                        'Đã sao chép liên kết Telegram @ngonsacviet!',
                        tone: AppFeedbackTone.success,
                      );
                    }
                  },
                ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading: const CircleAvatar(
                  child: Icon(Icons.ios_share_rounded, size: 20),
                ),
                title: const Text('Chia sẻ qua ứng dụng khác'),
                onTap: () async {
                  Navigator.pop(sheetCtx);
                  try {
                    await SharePlus.instance.share(ShareParams(text: fullText));
                  } catch (_) {
                    await Clipboard.setData(ClipboardData(text: fullText));
                    if (context.mounted) {
                      showAppSnack(
                        context,
                        'Đã sao chép để chia sẻ!',
                        tone: AppFeedbackTone.success,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedia(BuildContext context, String mediaFullUrl, {bool edgeToEdge = false}) {
    final post = widget.post;
    final theme = Theme.of(context);
    final radius = edgeToEdge
        ? const BorderRadius.vertical(top: Radius.circular(18))
        : BorderRadius.circular(14);

    if (post.mediaType == 'image' && mediaFullUrl.isNotEmpty) {
      return GestureDetector(
        onTap: () => _openImageLightbox(context, mediaFullUrl),
        child: ClipRRect(
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: edgeToEdge ? 250 : 380),
            child: Image.network(
              mediaFullUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: edgeToEdge ? 190 : 210,
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stack) => Container(
                height: 160,
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                child: const Center(
                  child: Icon(Icons.broken_image_outlined, size: 36),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (post.mediaType == 'video' && mediaFullUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: HeritageVideoPlayer(url: mediaFullUrl),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaFullUrl = widget.resolveUrl(post.mediaUrl);
    final hasMedia =
        (post.mediaType == 'image' || post.mediaType == 'video') &&
        mediaFullUrl.isNotEmpty;
    final initials = post.authorName.trim().isNotEmpty
        ? post.authorName.trim()[0].toUpperCase()
        : 'N';

    return Card(
      margin: EdgeInsets.only(bottom: widget.compactMediaFirst ? 0 : 14),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.compactMediaFirst && hasMedia)
            _buildMedia(context, mediaFullUrl, edgeToEdge: true),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 19,
                      backgroundColor:
                          theme.colorScheme.primary.withValues(alpha: 0.14),
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                post.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                ),
                              ),
                              if (widget.peopleName != null &&
                                  widget.peopleName!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: isDark ? 0.24 : 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    widget.peopleName!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_formatRelativeTime(post.createdAt)} · @ngonsacviet',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.56),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.showStatus) _StatusBadge(status: post.status),
                    if (widget.canDelete && widget.onDelete != null)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.delete_outline_rounded, size: 19),
                        tooltip: 'Xoá bài',
                        onPressed: widget.onDelete,
                      ),
                  ],
                ),

                // Title & body
                if (post.title.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    post.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
                if (post.body.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    post.body,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ],
                if (post.reviewNote != null &&
                    post.reviewNote!.isNotEmpty &&
                    widget.showStatus) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Ghi chú duyệt: ${post.reviewNote}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                // Decluttered Multi-Ethnic Translation trigger & drawer
                if (widget.onTranslate != null &&
                    (post.title.isNotEmpty || post.body.isNotEmpty)) ...[
                  const SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => setState(() {
                      _showTranslateBar = !_showTranslateBar;
                      if (!_showTranslateBar) {
                        _selectedLang = null;
                        _translateError = null;
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: isDark ? 0.16 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.translate_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _showTranslateBar
                                ? 'Ẩn bản dịch tiếng dân tộc'
                                : 'Xem bản dịch tiếng dân tộc',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            _showTranslateBar
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showTranslateBar) ...[
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final (code, label) in _translateChoices) ...[
                            ChoiceChip(
                              label: Text(
                                label,
                                style: const TextStyle(fontSize: 11.5),
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              selected: _selectedLang == code,
                              onSelected: (_) => _toggleTranslate(code),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ],
                      ),
                    ),
                    if (_selectedLang != null) ...[
                      const SizedBox(height: 8),
                      _buildTranslatedBox(context, isDark),
                    ],
                  ],
                ],

                // Standard inline media when not media-first
                if (!widget.compactMediaFirst && hasMedia) ...[
                  const SizedBox(height: 12),
                  _buildMedia(context, mediaFullUrl, edgeToEdge: false),
                ],

                // Reaction counts + Facebook-style action bar
                if (widget.onLike != null || widget.onComment != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: post.likedByMe
                              ? Colors.redAccent
                              : theme.colorScheme.primary.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          size: 12,
                          color: post.likedByMe
                              ? Colors.white
                              : theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.likeCount} lượt thích',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.68),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: widget.onComment,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          child: Text(
                            '${post.commentCount} bình luận',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.68),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    height: 1,
                    color:
                        theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionPillButton(
                          icon: post.likedByMe
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          label: post.likedByMe ? 'Đã thích' : 'Thích',
                          active: post.likedByMe,
                          activeColor: Colors.redAccent,
                          onPressed:
                              post.status == 'approved' ? widget.onLike : null,
                        ),
                      ),
                      Expanded(
                        child: _ActionPillButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'Bình luận',
                          onPressed: () {
                            if (widget.onQuickComment != null &&
                                post.status == 'approved') {
                              setState(() => _showQuickReply = !_showQuickReply);
                            } else {
                              widget.onComment?.call();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: _ActionPillButton(
                          icon: Icons.share_outlined,
                          label: 'Chia sẻ',
                          onPressed: () => _openShareSheet(context, post),
                        ),
                      ),
                    ],
                  ),
                ],

                // Clean inline comments preview + expandable quick reply
                if (post.status == 'approved' &&
                    (post.recentComments.isNotEmpty || _showQuickReply)) ...[
                  const SizedBox(height: 6),
                  Divider(
                    height: 1,
                    color:
                        theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 8),
                  for (final c in post.recentComments.take(2))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.12),
                            child: Text(
                              c.authorName.isNotEmpty
                                  ? c.authorName[0].toUpperCase()
                                  : 'N',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: isDark ? 0.38 : 0.5),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontSize: 13, height: 1.35),
                                  children: [
                                    TextSpan(
                                      text: '${c.authorName}  ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    TextSpan(text: c.body),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (post.commentCount > 2 && widget.onComment != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: InkWell(
                        onTap: widget.onComment,
                        child: Text(
                          'Xem tất cả ${post.commentCount} bình luận...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  if (_showQuickReply && widget.onQuickComment != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _quickCtrl,
                              enabled: !_sendingQuick,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendQuickComment(),
                              style: const TextStyle(fontSize: 13.5),
                              decoration: InputDecoration(
                                hintText: 'Viết bình luận nhanh...',
                                isDense: true,
                                filled: true,
                                fillColor: theme
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withValues(alpha: isDark ? 0.3 : 0.42),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 9,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton.filledTonal(
                            tooltip: 'Gửi bình luận',
                            onPressed: _sendingQuick ? null : _sendQuickComment,
                            icon: _sendingQuick
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.send_rounded, size: 18),
                          ),
                        ],
                      ),
                    ),
                ],

                if (widget.footerExtra != null) ...[
                  const SizedBox(height: 8),
                  widget.footerExtra!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslatedBox(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.14 : 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: _translating
          ? Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
                Text(
                  'Đang dịch sang tiếng ${_langName(_selectedLang!)}...',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            )
          : _translateError != null
          ? Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _translateError!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            )
          : Builder(
              builder: (context) {
                final tr = _translations[_selectedLang!];
                if (tr == null) return const SizedBox.shrink();
                final combined = [
                  if (tr.translatedTitle.isNotEmpty) tr.translatedTitle,
                  if (tr.translatedBody.isNotEmpty) tr.translatedBody,
                ].join('\n');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 15,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Bản dịch · ${_langName(_selectedLang!)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface
                                .withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            tr.engine,
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                        const Spacer(),
                        SpeechPlayButton(
                          tooltip: 'Nghe bản dịch tiếng ${_langName(_selectedLang!)}',
                          enabled: combined.trim().isNotEmpty,
                          buildUrl: () {
                            final trimmed = combined.trim().length > 550
                                ? combined.trim().substring(0, 550)
                                : combined.trim();
                            return widget.resolveUrl(
                              '/v1/translate/tts?lang=${Uri.encodeQueryComponent(_selectedLang!)}&text=${Uri.encodeQueryComponent(trimmed)}',
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Sao chép bản dịch',
                          constraints: const BoxConstraints.tightFor(
                            width: 30,
                            height: 30,
                          ),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: combined),
                            );
                            if (context.mounted) {
                              showAppSnack(
                                context,
                                'Đã sao chép bản dịch!',
                                tone: AppFeedbackTone.success,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    if (tr.translatedTitle.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        tr.translatedTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                    if (tr.translatedBody.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        tr.translatedBody,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                        ),
                      ),
                    ],
                    if (tr.warnings.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        tr.warnings.join(' '),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.62),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
    );
  }

  void _openImageLightbox(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(url, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionPillButton extends StatelessWidget {
  const _ActionPillButton({
    required this.icon,
    required this.label,
    this.active = false,
    this.activeColor,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool active;
  final Color? activeColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active
        ? (activeColor ?? theme.colorScheme.primary)
        : theme.colorScheme.onSurface
              .withValues(alpha: onPressed == null ? 0.35 : 0.78);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: active
            ? BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 19, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'approved' => ('Đã duyệt', Colors.green),
      'rejected' => ('Từ chối', Colors.redAccent),
      _ => ('Chờ duyệt', Colors.orange),
    };
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

String _formatRelativeTime(DateTime? dt) {
  if (dt == null) return 'Vừa xong';
  final diff = DateTime.now().toUtc().difference(dt.toUtc());
  if (diff.inMinutes < 1) return 'Vừa xong';
  if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
  if (diff.inDays < 1) return '${diff.inHours} giờ trước';
  if (diff.inDays < 7) return '${diff.inDays} ngày trước';
  return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}
