import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/wiring.dart';
import '../../../../domain/models/heritage_post.dart';
import '../../../../domain/models/models.dart';
import '../../../core/app_feedback.dart';

class HeritageComposerSheet extends ConsumerStatefulWidget {
  const HeritageComposerSheet({
    required this.peoples,
    this.initialPickMode,
    super.key,
  });

  final List<People> peoples;
  final String? initialPickMode; // 'image' | 'video' | null

  @override
  ConsumerState<HeritageComposerSheet> createState() =>
      _HeritageComposerSheetState();
}

class _HeritageComposerSheetState extends ConsumerState<HeritageComposerSheet> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  String _selectedSlug = 'all';
  Uint8List? _bytes;
  String? _filename;
  String? _contentType;
  String? _mediaKind; // 'image' | 'video'
  bool _submitting = false;

  static const int _maxImageBytes = 8 * 1024 * 1024;
  static const int _maxVideoBytes = 20 * 1024 * 1024;

  @override
  void initState() {
    super.initState();
    if (widget.initialPickMode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pickMedia(widget.initialPickMode!);
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(String kind) async {
    final result = await FilePicker.pickFiles(
      type: kind == 'video' ? FileType.video : FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      if (mounted) {
        showAppSnack(
          context,
          'Không đọc được dữ liệu tệp đã chọn.',
          tone: AppFeedbackTone.error,
        );
      }
      return;
    }
    final maxBytes = kind == 'video' ? _maxVideoBytes : _maxImageBytes;
    if (bytes.length > maxBytes) {
      if (mounted) {
        final limitMb = kind == 'video' ? 20 : 8;
        showAppSnack(
          context,
          'Tệp vượt quá giới hạn $limitMb MB để lưu trên kênh Telegram.',
          tone: AppFeedbackTone.warning,
        );
      }
      return;
    }
    final ext = (file.extension ?? (kind == 'video' ? 'mp4' : 'jpg')).toLowerCase();
    final mime = kind == 'video'
        ? (ext == 'mov'
              ? 'video/quicktime'
              : ext == 'webm'
              ? 'video/webm'
              : 'video/mp4')
        : (ext == 'png'
              ? 'image/png'
              : ext == 'webp'
              ? 'image/webp'
              : ext == 'gif'
              ? 'image/gif'
              : 'image/jpeg');
    if (!mounted) return;
    setState(() {
      _bytes = bytes;
      _filename = file.name;
      _contentType = mime;
      _mediaKind = kind;
    });
  }

  Future<void> _submit() async {
    final title = _title.text.trim();
    final body = _body.text.trim();
    if (title.isEmpty && body.isEmpty && _bytes == null) {
      showAppSnack(
        context,
        'Hãy viết vài dòng hoặc chọn ảnh/video văn hóa dân tộc.',
        tone: AppFeedbackTone.warning,
      );
      return;
    }
    setState(() => _submitting = true);
    final api = ref.read(apiClientProvider);
    try {
      final HeritagePost created = await api.guard(
        api.createHeritagePost(
          title: title,
          body: body,
          peopleSlug: _selectedSlug == 'all' ? null : _selectedSlug,
          fileBytes: _bytes,
          filename: _filename,
          contentType: _contentType,
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, created);
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Đăng bài lên Kênh Di Sản',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _submitting ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Text(
              'Bài sẽ được lưu trữ lên kênh @ngonsacviet và hiển thị sau khi rà soát viên duyệt.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedSlug,
              decoration: const InputDecoration(
                labelText: 'Dân tộc / Chủ đề',
                prefixIcon: Icon(Icons.groups_2_outlined),
              ),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('Chung nhiều dân tộc')),
                for (final people in widget.peoples)
                  DropdownMenuItem(value: people.slug, child: Text(people.nameVi)),
              ],
              onChanged: _submitting
                  ? null
                  : (v) {
                      if (v != null) setState(() => _selectedSlug = v);
                    },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _title,
              enabled: !_submitting,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề (tuỳ chọn)',
                hintText: 'Ví dụ: Lễ hội Lồng Tồng, Không gian cồng chiêng...',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _body,
              enabled: !_submitting,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Chia sẻ câu chuyện văn hóa',
                hintText: 'Kể về lễ hội, trang phục, nhạc cụ hoặc câu nói truyền thống...',
                alignLabelWithHint: true,
              ),
            ),
            if (_bytes != null) ...[
              const SizedBox(height: 12),
              Stack(
                children: [
                  if (_mediaKind == 'image')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.memory(
                        _bytes!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.video_file_rounded,
                            size: 32,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _filename ?? 'video.mp4',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${(_bytes!.length / (1024 * 1024)).toStringAsFixed(1)} MB · Đạt chuẩn Telegram',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton.filledTonal(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: _submitting
                          ? null
                          : () => setState(() {
                              _bytes = null;
                              _filename = null;
                              _contentType = null;
                              _mediaKind = null;
                            }),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _submitting ? null : () => _pickMedia('image'),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Chọn ảnh'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _submitting ? null : () => _pickMedia('video'),
                    icon: const Icon(Icons.videocam_outlined),
                    label: const Text('Chọn video (≤20MB)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(
                _submitting ? 'Đang tải lên @ngonsacviet...' : 'Đăng bài chờ duyệt',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
