import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/services/api_client.dart';
import '../../../../data/session_profile.dart';
import '../../../../data/wiring.dart';
import '../../../../domain/models/heritage_post.dart';
import '../../../../domain/models/models.dart';
import '../../../core/app_feedback.dart';
import '../../../core/app_theme.dart';
import '../../heritage/widgets/heritage_post_card.dart';
import '../../settings/view_models/settings_view_model.dart';

class AdminView extends ConsumerStatefulWidget {
  const AdminView({super.key});

  @override
  ConsumerState<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends ConsumerState<AdminView> with SingleTickerProviderStateMixin {
  TabController? _tabs;
  int _pendingCount = 0;
  Map<String, dynamic> _stats = const {};
  List<Contribution> _queue = const [];
  List<HeritagePost> _heritageQueue = const [];
  List<UserProfile> _users = const [];
  List<Map<String, dynamic>> _lessons = const [];
  String _queueStatus = 'pending';
  String _heritageStatus = 'pending';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _tabs?.dispose();
    super.dispose();
  }

  void _ensureTabs(bool isAdmin) {
    final length = isAdmin ? 5 : 4;
    if (_tabs != null && _tabs!.length == length) return;
    _tabs?.dispose();
    _tabs = TabController(length: length, vsync: this);
  }

  Future<void> _bootstrap() async {
    final profile = ref.read(sessionProfileProvider);
    if (!profile.isStaff) {
      if (!mounted) return;
      setState(() => _loading = false);
      return;
    }
    _ensureTabs(profile.isAdmin);
    await _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final api = ref.read(apiClientProvider);
    final profile = ref.read(sessionProfileProvider);
    try {
      final stats = await api.guard(api.adminStats());
      final queue = await api.guard(api.reviewQueue(status: _queueStatus));
      final heritageQueue = await api.guard(
        api.listHeritagePosts(status: _heritageStatus, limit: 50),
      );
      final lessons = await api.guard(api.adminLessons());
      List<UserProfile> users = const [];
      if (profile.isAdmin) {
        users = await api.guard(api.adminUsers());
      }
      if (!mounted) return;
      final byStatus = Map<String, dynamic>.from(stats['contributions_by_status'] as Map? ?? {});
      final heritageByStatus = Map<String, dynamic>.from(
        stats['heritage_posts_by_status'] as Map? ?? {},
      );
      setState(() {
        _stats = stats;
        _pendingCount =
            ((byStatus['pending'] as num?)?.toInt() ?? 0) +
            ((heritageByStatus['pending'] as num?)?.toInt() ?? 0);
        _queue = queue;
        _heritageQueue = heritageQueue;
        _lessons = lessons;
        _users = users;
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

  Future<void> _cycleTheme() async {
    final current = ref.read(settingsViewModelProvider).themeMode;
    final next = switch (current) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    await ref.read(settingsViewModelProvider.notifier).setTheme(next);
  }

  Future<void> _review(Contribution row, String status) async {
    final noteController = TextEditingController();
    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) {
          final approve = status == 'approved';
          final scheme = Theme.of(context).colorScheme;
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text(approve ? 'Duyệt câu này?' : 'Từ chối câu này?'),
            content: TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Ghi chú rà soát (tuỳ chọn)'),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
              FilledButton(
                style: approve
                    ? null
                    : FilledButton.styleFrom(backgroundColor: scheme.error),
                onPressed: () => Navigator.pop(context, true),
                child: Text(approve ? 'Duyệt' : 'Từ chối'),
              ),
            ],
          );
        },
      );
      if (ok != true || row.id == null) return;
      final api = ref.read(apiClientProvider);
      try {
        await api.guard(
          api.reviewContribution(
            id: row.id!,
            status: status,
            reviewNote: noteController.text,
          ),
        );
        if (!mounted) return;
        showAppSnack(
          context,
          status == 'approved' ? 'Đã duyệt câu.' : 'Đã từ chối câu.',
          tone: AppFeedbackTone.success,
        );
        await _reload();
      } catch (error) {
        if (!mounted) return;
        showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
      }
    } finally {
      noteController.dispose();
    }
  }

  Future<void> _reviewHeritage(HeritagePost post, String status) async {
    final noteController = TextEditingController();
    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) {
          final approve = status == 'approved';
          final scheme = Theme.of(context).colorScheme;
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: Text(approve ? 'Duyệt bài di sản này?' : 'Từ chối bài di sản?'),
            content: TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Ghi chú rà soát (tuỳ chọn)'),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
              FilledButton(
                style: approve
                    ? null
                    : FilledButton.styleFrom(backgroundColor: scheme.error),
                onPressed: () => Navigator.pop(context, true),
                child: Text(approve ? 'Duyệt bài' : 'Từ chối'),
              ),
            ],
          );
        },
      );
      if (ok != true) return;
      final api = ref.read(apiClientProvider);
      try {
        await api.guard(
          api.reviewHeritagePost(
            postId: post.id,
            status: status,
            reviewNote: noteController.text,
          ),
        );
        if (!mounted) return;
        showAppSnack(
          context,
          status == 'approved'
              ? 'Đã duyệt bài lên Kênh Di Sản & cập nhật @ngonsacviet.'
              : 'Đã từ chối và gỡ bài khỏi @ngonsacviet.',
          tone: AppFeedbackTone.success,
        );
        await _reload();
      } catch (error) {
        if (!mounted) return;
        showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
      }
    } finally {
      noteController.dispose();
    }
  }

  Future<void> _changeRole(UserProfile user) async {
    final me = ref.read(sessionProfileProvider);
    if (me.id != null && me.id == user.id) {
      showAppSnack(context, 'Không thể đổi vai trò của chính mình.', tone: AppFeedbackTone.warning);
      return;
    }
    final next = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              for (final role in const ['member', 'reviewer', 'admin'])
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  leading: Icon(_roleIcon(role), color: _brand(context)),
                  title: Text(_roleLabel(role)),
                  subtitle: Text(_roleHint(role)),
                  trailing: user.role == role
                      ? Icon(Icons.check_circle, color: AppTheme.accentJade)
                      : null,
                  onTap: () => Navigator.pop(context, role),
                ),
            ],
          ),
        ),
      ),
    );
    if (next == null || next == user.role) return;
    final api = ref.read(apiClientProvider);
    try {
      await api.guard(api.setUserRole(user.id, next));
      if (!mounted) return;
      showAppSnack(context, 'Đã cập nhật vai trò.', tone: AppFeedbackTone.success);
      await _reload();
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    }
  }

  Future<void> _openLessonEditor(Map<String, dynamic> summary) async {
    final api = ref.read(apiClientProvider);
    try {
      final detail = await api.guard(api.adminLesson(summary['id'] as String));
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => _LessonEditorSheet(
          lesson: detail,
          onChanged: _reload,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(sessionProfileProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAdmin = profile.isAdmin;
    final themeMode = ref.watch(settingsViewModelProvider).themeMode;

    if (!profile.isStaff) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: _pageGradient(isDark)),
          child: SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  title: const Text('Quản trị'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => context.canPop() ? context.pop() : context.go('/translate'),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: _SurfaceCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: _brand(context).withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.lock_outline_rounded, size: 34, color: _brand(context)),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Khu vực dành cho người rà soát',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Đăng nhập bằng tài khoản được cấp quyền để duyệt câu, sửa bài học và theo dõi hệ thống.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () => context.go('/login?next=/admin'),
                                  child: const Text('Đăng nhập'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    _ensureTabs(isAdmin);
    final tabs = _tabs!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _pageGradient(isDark)),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                titleSpacing: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.canPop() ? context.pop() : context.go('/translate'),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quản trị'),
                    Text(
                      profile.roleLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
                actions: [
                  if (_pendingCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentAmber.withValues(alpha: isDark ? 0.22 : 0.15),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppTheme.accentAmber.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            '$_pendingCount chờ duyệt',
                            style: TextStyle(
                              color: isDark ? const Color(0xFFFFD59A) : AppTheme.accentAmber,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  IconButton(
                    tooltip: _themeTooltip(themeMode),
                    onPressed: _cycleTheme,
                    icon: Icon(_themeIcon(themeMode)),
                  ),
                  IconButton(
                    tooltip: 'Tải lại',
                    onPressed: _loading ? null : _reload,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  const SizedBox(width: 4),
                ],
                bottom: TabBar(
                  controller: tabs,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: _brand(context),
                  labelColor: _brand(context),
                  unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  dividerColor: Colors.transparent,
                  tabs: [
                    const Tab(text: 'Tổng quan'),
                    const Tab(text: 'Duyệt câu'),
                    const Tab(text: 'Duyệt di sản'),
                    const Tab(text: 'Bài học'),
                    if (isAdmin) const Tab(text: 'Người dùng'),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? _ErrorPane(message: _error!, onRetry: _reload)
                        : TabBarView(
                            controller: tabs,
                            children: [
                              _OverviewPane(stats: _stats),
                              _ReviewPane(
                                queue: _queue,
                                status: _queueStatus,
                                onStatus: (value) async {
                                  setState(() => _queueStatus = value);
                                  await _reload();
                                },
                                onApprove: (row) => _review(row, 'approved'),
                                onReject: (row) => _review(row, 'rejected'),
                              ),
                              _HeritageReviewPane(
                                queue: _heritageQueue,
                                status: _heritageStatus,
                                resolveUrl: ref.read(apiClientProvider).resolveUrl,
                                onTranslate: (postId, targetLang) => ref.read(apiClientProvider).guard(
                                  ref.read(apiClientProvider).translateHeritagePost(
                                    postId: postId,
                                    targetLang: targetLang,
                                  ),
                                ),
                                onStatus: (value) async {
                                  setState(() => _heritageStatus = value);
                                  await _reload();
                                },
                                onApprove: (post) => _reviewHeritage(post, 'approved'),
                                onReject: (post) => _reviewHeritage(post, 'rejected'),
                              ),
                              _LessonsPane(lessons: _lessons, onOpen: _openLessonEditor),
                              if (isAdmin) _UsersPane(users: _users, onChangeRole: _changeRole),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _brand(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? AppTheme.primaryDarkColor : AppTheme.primaryColor;

LinearGradient _pageGradient(bool isDark) {
  if (isDark) {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A1210), Color(0xFF121212), Color(0xFF101418)],
    );
  }
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF8F1), Color(0xFFF8F5EE), Color(0xFFF3F6F4)],
  );
}

IconData _themeIcon(ThemeMode mode) => switch (mode) {
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
      ThemeMode.system => Icons.brightness_auto_rounded,
    };

String _themeTooltip(ThemeMode mode) => switch (mode) {
      ThemeMode.light => 'Đang sáng — chạm để tối',
      ThemeMode.dark => 'Đang tối — chạm theo hệ thống',
      ThemeMode.system => 'Theo hệ thống — chạm để sáng',
    };

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface.withValues(alpha: 0.92) : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.darkCardBorder : AppTheme.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class _ErrorPane extends StatelessWidget {
  const _ErrorPane({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _SurfaceCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, size: 40, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewPane extends StatelessWidget {
  const _OverviewPane({required this.stats});

  final Map<String, dynamic> stats;

  int _n(String key) => (stats[key] as num?)?.toInt() ?? 0;

  Map<String, dynamic> _map(String key) => Map<String, dynamic>.from(stats[key] as Map? ?? {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byStatus = _map('contributions_by_status');
    final heritageByStatus = _map('heritage_posts_by_status');
    final byRole = _map('users_by_role');
    final cards = [
      ('Người dùng', _n('users'), Icons.group_outlined, AppTheme.primaryColor),
      ('Bài học', _n('lessons'), Icons.menu_book_outlined, AppTheme.accentJade),
      ('Câu mẫu', _n('phrases'), Icons.short_text_rounded, AppTheme.accentAmber),
      ('Đã xác minh', _n('phrases_verified'), Icons.verified_outlined, AppTheme.accentJade),
      ('Chờ duyệt', (byStatus['pending'] as num?)?.toInt() ?? 0, Icons.hourglass_top_rounded, AppTheme.accentAmber),
      ('Đã duyệt', (byStatus['approved'] as num?)?.toInt() ?? 0, Icons.check_circle_outline, AppTheme.accentJade),
      ('Di sản chờ duyệt', (heritageByStatus['pending'] as num?)?.toInt() ?? 0, Icons.dynamic_feed_rounded, AppTheme.accentAmber),
      ('Di sản đã đăng', (heritageByStatus['approved'] as num?)?.toInt() ?? 0, Icons.photo_library_outlined, AppTheme.accentJade),
      ('Lượt dịch', _n('translation_logs'), Icons.translate_rounded, AppTheme.primaryColor),
      ('Quiz', _n('quiz_attempts'), Icons.quiz_outlined, AppTheme.accentAmber),
      ('Di sản', _n('heritage_items'), Icons.account_balance_outlined, AppTheme.primaryColor),
      ('Ngôn ngữ', _n('languages'), Icons.language_rounded, AppTheme.accentJade),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      children: [
        Text(
          'Bảng điều khiển',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Theo dõi đóng góp, bài học và hoạt động trên hệ thống.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 720 ? 4 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final card in cards)
              _StatTile(label: card.$1, value: '${card.$2}', icon: card.$3, accent: card.$4),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Phân quyền',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final role in const ['admin', 'reviewer', 'member'])
              _SurfaceCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_roleIcon(role), size: 18, color: _brand(context)),
                    const SizedBox(width: 8),
                    Text(
                      '${_roleLabel(role)} · ${(byRole[role] as num?)?.toInt() ?? 0}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.22 : 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isDark ? accent.withValues(alpha: 0.95) : accent, size: 20),
          ),
          const Spacer(),
          Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewPane extends StatelessWidget {
  const _ReviewPane({
    required this.queue,
    required this.status,
    required this.onStatus,
    required this.onApprove,
    required this.onReject,
  });

  final List<Contribution> queue;
  final String status;
  final ValueChanged<String> onStatus;
  final ValueChanged<Contribution> onApprove;
  final ValueChanged<Contribution> onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: _SurfaceCard(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                for (final item in const [
                  ('pending', 'Chờ'),
                  ('approved', 'Đã duyệt'),
                  ('rejected', 'Từ chối'),
                ])
                  Expanded(
                    child: _FilterChip(
                      label: item.$2,
                      selected: status == item.$1,
                      onTap: () => onStatus(item.$1),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: queue.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 44,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Không có câu trong mục này',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                  itemCount: queue.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final row = queue[index];
                    return _ContributionCard(
                      row: row,
                      showActions: status == 'pending',
                      onApprove: () => onApprove(row),
                      onReject: () => onReject(row),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _HeritageReviewPane extends StatelessWidget {
  const _HeritageReviewPane({
    required this.queue,
    required this.status,
    required this.resolveUrl,
    required this.onTranslate,
    required this.onStatus,
    required this.onApprove,
    required this.onReject,
  });

  final List<HeritagePost> queue;
  final String status;
  final String Function(String? path) resolveUrl;
  final Future<HeritagePostTranslation> Function(String postId, String targetLang) onTranslate;
  final ValueChanged<String> onStatus;
  final ValueChanged<HeritagePost> onApprove;
  final ValueChanged<HeritagePost> onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: _SurfaceCard(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                for (final item in const [
                  ('pending', 'Chờ duyệt'),
                  ('approved', 'Đã duyệt'),
                  ('rejected', 'Từ chối'),
                ])
                  Expanded(
                    child: _FilterChip(
                      label: item.$2,
                      selected: status == item.$1,
                      onTap: () => onStatus(item.$1),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: queue.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dynamic_feed_outlined,
                        size: 44,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Không có bài di sản trong mục này',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                  itemCount: queue.length,
                  itemBuilder: (context, index) {
                    final post = queue[index];
                    return HeritagePostCard(
                      post: post,
                      resolveUrl: resolveUrl,
                      peopleName: post.peopleSlug,
                      showStatus: true,
                      onTranslate: (targetLang) => onTranslate(post.id, targetLang),
                      footerExtra: status == 'pending'
                          ? Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => onReject(post),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: theme.colorScheme.error,
                                      side: BorderSide(
                                        color: theme.colorScheme.error.withValues(alpha: 0.35),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text('Từ chối'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () => onApprove(post),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text('Duyệt bài'),
                                  ),
                                ),
                              ],
                            )
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = _brand(context);
    return Material(
      color: selected ? brand : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: selected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContributionCard extends StatelessWidget {
  const _ContributionCard({
    required this.row,
    required this.showActions,
    required this.onApprove,
    required this.onReject,
  });

  final Contribution row;
  final bool showActions;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _brand(context).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${row.sourceLang} → ${row.targetLang}',
                  style: TextStyle(
                    color: _brand(context),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                row.languageCode.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(row.sourceText, style: theme.textTheme.titleMedium?.copyWith(height: 1.35)),
          const SizedBox(height: 6),
          Text(
            row.targetText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: _brand(context),
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          if (row.note != null && row.note!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                row.note!,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
              ),
            ),
          ],
          if (showActions) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.35)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Từ chối'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: onApprove,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Duyệt'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LessonsPane extends StatelessWidget {
  const _LessonsPane({required this.lessons, required this.onOpen});

  final List<Map<String, dynamic>> lessons;
  final ValueChanged<Map<String, dynamic>> onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (lessons.isEmpty) {
      return const Center(child: Text('Chưa có bài học.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      itemCount: lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final row = lessons[index];
        final verified = (row['phrase_verified'] as num?)?.toInt() ?? 0;
        final total = (row['phrase_total'] as num?)?.toInt() ?? 0;
        final questions = (row['question_total'] as num?)?.toInt() ?? 0;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onOpen(row),
            child: _SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _brand(context).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${row['language_code']}'.toUpperCase(),
                          style: TextStyle(
                            color: _brand(context),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${row['level']}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.edit_outlined, size: 18, color: theme.colorScheme.outline),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${row['title_vi']}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${row['summary_vi']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$verified/$total câu đã xác minh · $questions câu hỏi',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LessonEditorSheet extends ConsumerStatefulWidget {
  const _LessonEditorSheet({required this.lesson, required this.onChanged});

  final Map<String, dynamic> lesson;
  final Future<void> Function() onChanged;

  @override
  ConsumerState<_LessonEditorSheet> createState() => _LessonEditorSheetState();
}

class _LessonEditorSheetState extends ConsumerState<_LessonEditorSheet> {
  late final TextEditingController _titleVi;
  late final TextEditingController _titleEn;
  late final TextEditingController _summaryVi;
  late final TextEditingController _summaryEn;
  late String _level;
  late List<Map<String, dynamic>> _phrases;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final lesson = widget.lesson;
    _titleVi = TextEditingController(text: '${lesson['title_vi'] ?? ''}');
    _titleEn = TextEditingController(text: '${lesson['title_en'] ?? ''}');
    _summaryVi = TextEditingController(text: '${lesson['summary_vi'] ?? ''}');
    _summaryEn = TextEditingController(text: '${lesson['summary_en'] ?? ''}');
    _level = '${lesson['level'] ?? 'basic'}';
    _phrases = (lesson['phrases'] as List? ?? const [])
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  @override
  void dispose() {
    _titleVi.dispose();
    _titleEn.dispose();
    _summaryVi.dispose();
    _summaryEn.dispose();
    super.dispose();
  }

  Future<void> _saveMeta() async {
    setState(() => _saving = true);
    final api = ref.read(apiClientProvider);
    try {
      final updated = await api.guard(
        api.updateAdminLesson(
          widget.lesson['id'] as String,
          titleVi: _titleVi.text.trim(),
          titleEn: _titleEn.text.trim(),
          summaryVi: _summaryVi.text.trim(),
          summaryEn: _summaryEn.text.trim(),
          level: _level,
        ),
      );
      if (!mounted) return;
      setState(() {
        _phrases = (updated['phrases'] as List? ?? const [])
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        _saving = false;
      });
      showAppSnack(context, 'Đã lưu bài học.', tone: AppFeedbackTone.success);
      await widget.onChanged();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    }
  }

  Future<void> _addPhrase() async {
    final native = TextEditingController();
    final vi = TextEditingController();
    final en = TextEditingController();
    var verified = false;
    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialog) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: const Text('Thêm câu mẫu'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: native,
                    decoration: const InputDecoration(
                      labelText: 'Câu tiếng dân tộc (đã xác minh)',
                      helperText: 'Chỉ nhập câu đã được cộng đồng xác nhận.',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: vi, decoration: const InputDecoration(labelText: 'Tiếng Việt')),
                  const SizedBox(height: 10),
                  TextField(controller: en, decoration: const InputDecoration(labelText: 'English')),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Đã xác minh'),
                    value: verified,
                    onChanged: (value) => setDialog(() => verified = value),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Thêm')),
            ],
          ),
        ),
      );
      if (ok != true) return;
      if (native.text.trim().isEmpty || vi.text.trim().isEmpty) {
        if (!mounted) return;
        showAppSnack(context, 'Cần đủ câu nguồn và tiếng Việt.', tone: AppFeedbackTone.warning);
        return;
      }
      final api = ref.read(apiClientProvider);
      final created = await api.guard(
        api.addAdminPhrase(
          widget.lesson['id'] as String,
          nativeText: native.text.trim(),
          viText: vi.text.trim(),
          enText: en.text.trim(),
          verified: verified,
        ),
      );
      if (!mounted) return;
      setState(() => _phrases = [..._phrases, created]);
      showAppSnack(context, 'Đã thêm câu mẫu.', tone: AppFeedbackTone.success);
      await widget.onChanged();
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    } finally {
      native.dispose();
      vi.dispose();
      en.dispose();
    }
  }

  Future<void> _toggleVerified(Map<String, dynamic> phrase) async {
    final api = ref.read(apiClientProvider);
    try {
      final updated = await api.guard(
        api.updateAdminPhrase(
          phrase['id'] as String,
          verified: !(phrase['verified'] as bool? ?? false),
        ),
      );
      if (!mounted) return;
      setState(() {
        _phrases = [
          for (final row in _phrases)
            if (row['id'] == updated['id']) updated else row,
        ];
      });
      await widget.onChanged();
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    }
  }

  Future<void> _deletePhrase(Map<String, dynamic> phrase) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Xoá câu mẫu?'),
        content: Text('${phrase['native_text']}\n${phrase['vi_text']}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final api = ref.read(apiClientProvider);
    try {
      await api.guard(api.deleteAdminPhrase(phrase['id'] as String));
      if (!mounted) return;
      setState(() => _phrases = _phrases.where((row) => row['id'] != phrase['id']).toList());
      showAppSnack(context, 'Đã xoá câu mẫu.', tone: AppFeedbackTone.success);
      await widget.onChanged();
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, error.toString(), tone: AppFeedbackTone.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.88,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sửa bài học',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              '${widget.lesson['language_code']}'.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(color: _brand(context)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  TextField(controller: _titleVi, decoration: const InputDecoration(labelText: 'Tiêu đề (VI)')),
                  const SizedBox(height: 10),
                  TextField(controller: _titleEn, decoration: const InputDecoration(labelText: 'Title (EN)')),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _summaryVi,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Tóm tắt (VI)'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _summaryEn,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Summary (EN)'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _level,
                    decoration: const InputDecoration(labelText: 'Cấp độ'),
                    items: const [
                      DropdownMenuItem(value: 'basic', child: Text('basic')),
                      DropdownMenuItem(value: 'intermediate', child: Text('intermediate')),
                      DropdownMenuItem(value: 'advanced', child: Text('advanced')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _level = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: _saving ? null : _saveMeta,
                    child: Text(_saving ? 'Đang lưu…' : 'Lưu metadata'),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Text(
                        'Câu mẫu (${_phrases.length})',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _addPhrase,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Thêm'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final phrase in _phrases)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SurfaceCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${phrase['native_text']}',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text('${phrase['vi_text']}'),
                            if ('${phrase['en_text'] ?? ''}'.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${phrase['en_text']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                FilterChip(
                                  selected: phrase['verified'] == true,
                                  label: Text(phrase['verified'] == true ? 'Đã xác minh' : 'Chưa xác minh'),
                                  onSelected: (_) => _toggleVerified(phrase),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: 'Xoá',
                                  onPressed: () => _deletePhrase(phrase),
                                  icon: const Icon(Icons.delete_outline_rounded),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersPane extends StatelessWidget {
  const _UsersPane({required this.users, required this.onChangeRole});

  final List<UserProfile> users;
  final ValueChanged<UserProfile> onChangeRole;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('Chưa có người dùng.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final user = users[index];
        return _SurfaceCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: _brand(context).withValues(alpha: 0.12),
              child: Text(
                user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
                style: TextStyle(color: _brand(context), fontWeight: FontWeight.w800),
              ),
            ),
            title: Text(user.displayName, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(user.email),
            trailing: FilledButton.tonal(
              onPressed: () => onChangeRole(user),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(_roleLabel(user.role)),
            ),
          ),
        );
      },
    );
  }
}

IconData _roleIcon(String role) {
  switch (role) {
    case 'admin':
      return Icons.admin_panel_settings_outlined;
    case 'reviewer':
      return Icons.fact_check_outlined;
    default:
      return Icons.person_outline_rounded;
  }
}

String _roleLabel(String role) {
  switch (role) {
    case 'admin':
      return 'Admin';
    case 'reviewer':
      return 'Rà soát';
    default:
      return 'Thành viên';
  }
}

String _roleHint(String role) {
  switch (role) {
    case 'admin':
      return 'Duyệt câu, sửa bài học và phân quyền';
    case 'reviewer':
      return 'Duyệt câu và sửa bài học';
    default:
      return 'Dùng app bình thường';
  }
}
