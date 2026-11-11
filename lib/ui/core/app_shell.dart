import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../domain/sync_use_case.dart';
import '../app_providers.dart';

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

  Future<void> _sync() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    try {
      final report = await ref.read(syncRunnerProvider)();
      ref.invalidate(languagesProvider);
      ref.invalidate(peoplesProvider);
      ref.invalidate(lessonsProvider);
      ref.invalidate(contributionsProvider);
      if (mounted) setState(() => _report = report);
    } catch (_) {
      // Offline fallback handling
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 48,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.translate_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        titleSpacing: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Bản Ngữ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  '+',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            Text(
              'Di sản ngôn ngữ dân tộc',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.sync,
            onPressed: _sync,
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
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => context.push('/settings'),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    child: const Text(
                      'NL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B261E),
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
                        color: Colors.green,
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
              color: Colors.amber.shade100,
              child: Row(
                children: [
                  const Icon(Icons.cloud_off_rounded, size: 16, color: Colors.brown),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.offlineSaved,
                      style: const TextStyle(fontSize: 12, color: Colors.brown),
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
