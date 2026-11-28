import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/services/api_client.dart';
import '../../../../data/session_profile.dart';
import '../../../../data/wiring.dart';
import '../../../../domain/models/heritage_post.dart';
import '../../../../domain/models/models.dart';
import '../../../core/app_feedback.dart';
import '../widgets/heritage_comments_sheet.dart';
import '../widgets/heritage_composer_sheet.dart';
import '../widgets/heritage_post_card.dart';

class HeritageFeedPane extends ConsumerStatefulWidget {
  const HeritageFeedPane({
    required this.peoples,
    this.showStoryRings = false,
    this.twoColumnDesktop = false,
    this.compactMediaFirst = false,
    this.embeddedInScroll = false,
    this.externalPeopleSlug,
    this.onPeopleFilterChanged,
    super.key,
  });

  final List<People> peoples;
  final bool showStoryRings;
  final bool twoColumnDesktop;
  final bool compactMediaFirst;
  final bool embeddedInScroll;
  final String? externalPeopleSlug;
  final ValueChanged<String>? onPeopleFilterChanged;

  @override
  ConsumerState<HeritageFeedPane> createState() => _HeritageFeedPaneState();
}

class _HeritageFeedPaneState extends ConsumerState<HeritageFeedPane> {
  List<HeritagePost> _posts = const [];
  bool _loading = true;
  String? _error;
  String _selectedPeopleSlug = 'all';
  String _mediaType = 'all';
  bool _onlyMine = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.externalPeopleSlug != null) {
      _selectedPeopleSlug = widget.externalPeopleSlug!;
    }
    _reload();
  }

  @override
  void didUpdateWidget(covariant HeritageFeedPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.externalPeopleSlug != null &&
        widget.externalPeopleSlug != oldWidget.externalPeopleSlug &&
        widget.externalPeopleSlug != _selectedPeopleSlug) {
      setState(() {
        _onlyMine = false;
        _selectedPeopleSlug = widget.externalPeopleSlug!;
      });
      _reload();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectPeopleSlug(String slug) {
    setState(() {
      _onlyMine = false;
      _selectedPeopleSlug = slug;
    });
    widget.onPeopleFilterChanged?.call(slug);
    _reload();
  }

  Future<void> _reload() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final api = ref.read(apiClientProvider);
    final profile = ref.read(sessionProfileProvider);
    try {
      final rows = await api.guard(
        api.listHeritagePosts(
          status: _onlyMine ? 'all' : 'approved',
          mine: _onlyMine && profile.isSignedIn,
          peopleSlug: _selectedPeopleSlug,
          mediaType: _mediaType,
          query: _searchController.text,
        ),
      );
      if (!mounted) return;
      setState(() {
        _posts = rows;
        _loading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.message;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _openComposer({String? pickMode}) async {
    final profile = ref.read(sessionProfileProvider);
    if (!profile.isSignedIn) {
      showAppSnack(
        context,
        'Hãy đăng nhập để đăng ảnh/video lên Kênh Di Sản.',
        tone: AppFeedbackTone.warning,
      );
      context.push('/login?next=/heritage');
      return;
    }
    final created = await showModalBottomSheet<HeritagePost>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => HeritageComposerSheet(
        peoples: widget.peoples,
        initialPickMode: pickMode,
      ),
    );
    if (created != null && mounted) {
      showAppSnack(
        context,
        'Đã lưu bài lên @ngonsacviet và gửi chờ rà soát viên duyệt.',
        tone: AppFeedbackTone.success,
      );
      if (!_onlyMine) {
        setState(() => _onlyMine = true);
      }
      await _reload();
    }
  }

  Future<void> _toggleLike(HeritagePost post) async {
    final profile = ref.read(sessionProfileProvider);
    if (!profile.isSignedIn) {
      context.push('/login?next=/heritage');
      return;
    }
    final idx = _posts.indexWhere((p) => p.id == post.id);
    if (idx < 0) return;

    final optimistic = post.copyWith(
      likedByMe: !post.likedByMe,
      likeCount: post.likedByMe
          ? (post.likeCount > 0 ? post.likeCount - 1 : 0)
          : post.likeCount + 1,
    );
    setState(() {
      _posts = [..._posts]..[idx] = optimistic;
    });

    final api = ref.read(apiClientProvider);
    try {
      final res = await api.guard(api.toggleHeritageLike(post.id));
      if (!mounted) return;
      final nowIdx = _posts.indexWhere((p) => p.id == post.id);
      if (nowIdx >= 0) {
        setState(() {
          _posts = [..._posts]
            ..[nowIdx] = _posts[nowIdx].copyWith(
              likedByMe: res.liked,
              likeCount: res.likeCount,
            );
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _posts = [..._posts]..[idx] = post;
      });
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    }
  }

  Future<void> _openComments(HeritagePost post) async {
    final updatedCount = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => HeritageCommentsSheet(post: post),
    );
    if (updatedCount != null && mounted) {
      await _reload();
    }
  }

  Future<void> _submitQuickComment(HeritagePost post, String text) async {
    final profile = ref.read(sessionProfileProvider);
    if (!profile.isSignedIn) {
      showAppSnack(
        context,
        'Hãy đăng nhập để bình luận bài viết.',
        tone: AppFeedbackTone.warning,
      );
      context.push('/login?next=/heritage');
      return;
    }
    final api = ref.read(apiClientProvider);
    try {
      final created = await api.guard(api.addHeritageComment(post.id, text));
      if (!mounted) return;
      final idx = _posts.indexWhere((p) => p.id == post.id);
      if (idx >= 0) {
        final nextComments = [..._posts[idx].recentComments, created];
        final trimmed = nextComments.length > 3
            ? nextComments.sublist(nextComments.length - 3)
            : nextComments;
        setState(() {
          _posts = [..._posts]
            ..[idx] = _posts[idx].copyWith(
              commentCount: _posts[idx].commentCount + 1,
              recentComments: trimmed,
            );
        });
      }
      showAppSnack(context, 'Đã gửi bình luận.', tone: AppFeedbackTone.success);
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    }
  }

  Future<void> _deletePost(HeritagePost post) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xoá bài di sản?'),
        content: const Text(
          'Bài viết sẽ bị gỡ khỏi Kênh Di Sản và kênh Telegram @ngonsacviet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final api = ref.read(apiClientProvider);
    try {
      await api.guard(api.deleteHeritagePost(post.id));
      if (!mounted) return;
      setState(() => _posts = _posts.where((p) => p.id != post.id).toList());
      showAppSnack(context, 'Đã xoá bài viết.', tone: AppFeedbackTone.success);
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    }
  }

  Widget _buildStoryRingBar(BuildContext context) {
    final theme = Theme.of(context);
    People? activePeople;
    if (_selectedPeopleSlug != 'all') {
      for (final p in widget.peoples) {
        if (p.slug == _selectedPeopleSlug) {
          activePeople = p;
          break;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 82,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _StoryAvatar(
                label: 'Tất cả',
                initial: '✦',
                selected: !_onlyMine && _selectedPeopleSlug == 'all',
                onTap: () => _selectPeopleSlug('all'),
              ),
              for (final people in widget.peoples)
                _StoryAvatar(
                  label: people.nameVi.replaceFirst('Người ', ''),
                  initial: people.nameVi
                      .replaceFirst('Người ', '')
                      .characters
                      .first,
                  selected: !_onlyMine && _selectedPeopleSlug == people.slug,
                  onTap: () => _selectPeopleSlug(people.slug),
                ),
            ],
          ),
        ),
        if (activePeople != null) ...[
          const SizedBox(height: 8),
          Card(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${activePeople.nameVi} · ${activePeople.family}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activePeople.regionVi,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        context.go('/heritage/${activePeople!.slug}'),
                    icon: const Icon(Icons.menu_book_rounded, size: 16),
                    label: const Text('Hồ sơ'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    HeritagePost post,
    Map<String, String> slugToName,
    SessionProfile profile,
    ApiClient api,
  ) {
    return HeritagePostCard(
      post: post,
      resolveUrl: api.resolveUrl,
      peopleName: post.peopleSlug != null
          ? slugToName[post.peopleSlug] ?? post.peopleSlug
          : null,
      showStatus: _onlyMine || post.status != 'approved',
      compactMediaFirst: widget.compactMediaFirst,
      canDelete:
          profile.isStaff ||
          (profile.id != null && profile.id == post.authorId),
      onLike: () => _toggleLike(post),
      onComment: () => _openComments(post),
      onQuickComment: (text) => _submitQuickComment(post, text),
      onTranslate: (targetLang) => api.guard(
        api.translateHeritagePost(postId: post.id, targetLang: targetLang),
      ),
      onDelete: () => _deletePost(post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = ref.watch(sessionProfileProvider);
    final api = ref.read(apiClientProvider);
    final slugToName = {for (final p in widget.peoples) p.slug: p.nameVi};
    final isWide = MediaQuery.sizeOf(context).width >= 880;

    final children = <Widget>[
      if (widget.showStoryRings) ...[
        _buildStoryRingBar(context),
        const SizedBox(height: 10),
      ],

      // Facebook-style Composer Card
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.14,
                    ),
                    child: Text(
                      profile.isSignedIn ? profile.initials : 'N',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => _openComposer(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Chia sẻ ảnh, video, câu chuyện di sản dân tộc...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _openComposer(pickMode: 'image'),
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        color: Colors.green,
                        size: 19,
                      ),
                      label: const Text('Ảnh'),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _openComposer(pickMode: 'video'),
                      icon: const Icon(
                        Icons.videocam_outlined,
                        color: Colors.deepOrange,
                        size: 20,
                      ),
                      label: const Text('Video'),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _openComposer(),
                      icon: const Icon(Icons.edit_note_rounded, size: 20),
                      label: const Text('Bài viết'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),

      // Search + Mine + Media filters
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _reload(),
              decoration: InputDecoration(
                hintText: 'Tìm bài viết trên Kênh Di Sản...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _reload();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ),
          if (profile.isSignedIn) ...[
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Bài của tôi'),
              selected: _onlyMine,
              onSelected: (_) {
                setState(() => _onlyMine = !_onlyMine);
                _reload();
              },
            ),
          ],
        ],
      ),
      if (!widget.showStoryRings) ...[
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ChoiceChip(
                label: const Text('Tất cả dân tộc'),
                selected: !_onlyMine && _selectedPeopleSlug == 'all',
                onSelected: (_) => _selectPeopleSlug('all'),
              ),
              for (final people in widget.peoples) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(people.nameVi),
                  selected: !_onlyMine && _selectedPeopleSlug == people.slug,
                  onSelected: (_) => _selectPeopleSlug(people.slug),
                ),
              ],
            ],
          ),
        ),
      ],
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final item in const [
              ('all', 'Mọi định dạng'),
              ('image', 'Có ảnh'),
              ('video', 'Có video'),
              ('text', 'Chỉ chữ'),
            ]) ...[
              FilterChip(
                label: Text(item.$2, style: const TextStyle(fontSize: 12)),
                visualDensity: VisualDensity.compact,
                selected: _mediaType == item.$1,
                onSelected: (_) {
                  setState(() => _mediaType = item.$1);
                  _reload();
                },
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),

      if (_loading)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (_error != null)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(onPressed: _reload, child: const Text('Thử lại')),
              ],
            ),
          ),
        )
      else if (_posts.isEmpty)
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              children: [
                Icon(
                  Icons.auto_awesome_mosaic_outlined,
                  size: 44,
                  color: theme.colorScheme.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 12),
                Text(
                  _onlyMine
                      ? 'Bạn chưa đăng bài di sản nào'
                      : 'Chưa có bài viết di sản nào trong mục này',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hãy là người đầu tiên chia sẻ ảnh hoặc video văn hóa dân tộc lên kênh @ngonsacviet!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _openComposer(),
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Đăng bài ngay'),
                ),
              ],
            ),
          ),
        )
      else if (widget.twoColumnDesktop && isWide)
        LayoutBuilder(
          builder: (context, constraints) {
            final colWidth = (constraints.maxWidth - 16) / 2;
            final leftPosts = <HeritagePost>[];
            final rightPosts = <HeritagePost>[];
            for (var i = 0; i < _posts.length; i++) {
              (i.isEven ? leftPosts : rightPosts).add(_posts[i]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: colWidth,
                  child: Column(
                    children: [
                      for (final p in leftPosts) ...[
                        _buildPostCard(context, p, slugToName, profile, api),
                        const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: colWidth,
                  child: Column(
                    children: [
                      for (final p in rightPosts) ...[
                        _buildPostCard(context, p, slugToName, profile, api),
                        const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        )
      else
        for (final post in _posts)
          _buildPostCard(context, post, slugToName, profile, api),
    ];

    if (widget.embeddedInScroll) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }

    final maxWidth = widget.twoColumnDesktop ? 1140.0 : 720.0;
    return RefreshIndicator(
      onRefresh: _reload,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            children: children,
          ),
        ),
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({
    required this.label,
    required this.initial,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String initial;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 62,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: selected ? 2.2 : 1.2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withValues(alpha: 0.11),
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: selected
                          ? Colors.white
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  color: selected ? theme.colorScheme.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
