import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  Future<void> _sync() async {
    final report = await ref.read(syncRunnerProvider)();
    ref.invalidate(languagesProvider);
    ref.invalidate(peoplesProvider);
    ref.invalidate(lessonsProvider);
    ref.invalidate(contributionsProvider);
    if (mounted) setState(() => _report = report);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(tooltip: l10n.sync, onPressed: _sync, icon: const Icon(Icons.sync)),
          IconButton(
            tooltip: l10n.account,
            onPressed: () => context.push('/login'),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: l10n.settings,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_report != null && !_report!.online)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.offlineSaved),
            ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: widget.navigationShell.goBranch,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.translate), label: l10n.tabTranslate),
          NavigationDestination(icon: const Icon(Icons.museum_outlined), label: l10n.tabHeritage),
          NavigationDestination(icon: const Icon(Icons.school_outlined), label: l10n.tabLearn),
          NavigationDestination(icon: const Icon(Icons.volunteer_activism_outlined), label: l10n.tabContribute),
        ],
      ),
    );
  }
}
