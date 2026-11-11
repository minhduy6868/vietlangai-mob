import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../data/session_profile.dart';
import '../../domain/sync_use_case.dart';
import '../app_providers.dart';
import 'app_feedback.dart';
import 'brand_assets.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  SyncReport? _report;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  Future<void> _sync({bool notify = false}) async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    try {
      final report = await ref.read(syncRunnerProvider)();
      ref.invalidate(languagesProvider);
      ref.invalidate(peoplesProvider);
      ref.invalidate(lessonsProvider);
      ref.invalidate(contributionsProvider);
      if (!mounted) return;
      setState(() => _report = report);
      if (notify) {
        final l10n = AppLocalizations.of(context);
        showAppSnack(
          context,
          report.online ? l10n.online : l10n.offlineSaved,
          tone: report.online ? AppFeedbackTone.success : AppFeedbackTone.warning,
        );
      }
    } catch (_) {
      if (mounted && notify) {
        showAppSnack(context, 'Không đồng bộ được máy chủ.', tone: AppFeedbackTone.error);
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: BrandMarkRow(
          title: l10n.appTitle,
          subtitle: 'Dịch · Học · Di sản tiếng dân tộc',
          logoSize: 36,
        ),
        actions: [
          IconButton(
            tooltip: l10n.sync,
            onPressed: () => _sync(notify: true),
            icon: _isSyncing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.sync_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, left: 4),
            child: Builder(
              builder: (context) {
                final profile = ref.watch(sessionProfileProvider);
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => context.push(profile.isSignedIn ? '/settings' : '/login'),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        child: Text(
                          profile.isSignedIn ? profile.initials : '?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: profile.isSignedIn ? Colors.green : Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_report != null && !_report!.online)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF3A2E1A)
                  : Colors.amber.shade100,
              child: Row(
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 16,
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFFE8C27A)
                        : Colors.brown,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.offlineSaved,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.brightness == Brightness.dark
                            ? const Color(0xFFE8C27A)
                            : Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: widget.navigationShell.goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.translate_rounded),
            selectedIcon: const Icon(Icons.translate_rounded),
            label: l10n.tabTranslate,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_stories_outlined),
            selectedIcon: const Icon(Icons.auto_stories_rounded),
            label: l10n.tabHeritage,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book_rounded),
            label: l10n.tabLearn,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.tabContribute,
          ),
        ],
      ),
    );
  }
}
