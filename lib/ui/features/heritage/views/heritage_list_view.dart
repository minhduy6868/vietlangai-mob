import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';
import '../../../core/async_value_view.dart';
import '../../settings/view_models/settings_view_model.dart';
import 'heritage_feed_pane.dart';

class HeritageListView extends ConsumerStatefulWidget {
  const HeritageListView({super.key});

  @override
  ConsumerState<HeritageListView> createState() => _HeritageListViewState();
}

class _HeritageListViewState extends ConsumerState<HeritageListView> {
  bool _showSocialFeed = true;
  String _selectedCategory = 'Tất cả';
  String _feedFilterSlug = 'all';
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _ancientScripts = [
    {
      'title': 'Chữ Akhar Thrah',
      'ethnic': 'Dân tộc Chăm',
      'glyphs': 'ꨀ  ꨁ  ꨂ  ꨃ  ꨄ',
      'count': 'Lớp OCR riêng cho chữ Chăm',
      'family': 'Austronesian, Chamic',
      'color': const Color(0xFF8B261E),
      'slug': 'cham',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final peoplesAsync = ref.watch(peoplesProvider);

    return AsyncValueView(
      value: peoplesAsync,
      builder: (rows) {
        if (rows.isEmpty) return Center(child: Text(l10n.emptyPeoples));

        final categories = [
          'Tất cả',
          for (final people in rows)
            locale == 'vi' ? people.nameVi : people.nameEn,
        ];
        final filteredRows = rows.where((people) {
          final title = (locale == 'vi' ? people.nameVi : people.nameEn)
              .toLowerCase();
          final matchesSearch =
              _searchController.text.isEmpty ||
              title.contains(_searchController.text.toLowerCase()) ||
              people.regionVi.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              );
          final matchesCategory =
              _selectedCategory == 'Tất cả' ||
              title.contains(_selectedCategory.toLowerCase());
          return matchesSearch && matchesCategory;
        }).toList();

        final isWide = MediaQuery.sizeOf(context).width >= 960;

        if (!isWide) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      icon: Icon(Icons.dynamic_feed_rounded, size: 18),
                      label: Text('Kênh Di Sản'),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      icon: Icon(Icons.menu_book_rounded, size: 18),
                      label: Text('10 Dân tộc'),
                    ),
                  ],
                  selected: {_showSocialFeed},
                  onSelectionChanged: (selection) {
                    setState(() => _showSocialFeed = selection.first);
                  },
                ),
              ),
              Expanded(
                child: _showSocialFeed
                    ? HeritageFeedPane(
                        peoples: rows,
                        externalPeopleSlug: _feedFilterSlug,
                        onPeopleFilterChanged: (slug) => _feedFilterSlug = slug,
                      )
                    : _buildExplorePane(
                        context,
                        rows: rows,
                        categories: categories,
                        filteredRows: filteredRows,
                        locale: locale,
                        isDark: isDark,
                        filterFeedOnTap: false,
                      ),
              ),
            ],
          );
        }

        // Studio 2-column Split Portal on Desktop
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 62,
                    child: HeritageFeedPane(
                      peoples: rows,
                      embeddedInScroll: true,
                      externalPeopleSlug: _feedFilterSlug,
                      onPeopleFilterChanged: (slug) =>
                          setState(() => _feedFilterSlug = slug),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 38,
                    child: _buildExplorePane(
                      context,
                      rows: rows,
                      categories: categories,
                      filteredRows: filteredRows,
                      locale: locale,
                      isDark: isDark,
                      embeddedInScroll: true,
                      filterFeedOnTap: true,
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

  Widget _buildExplorePane(
    BuildContext context, {
    required List<People> rows,
    required List<String> categories,
    required List<People> filteredRows,
    required String locale,
    required bool isDark,
    bool embeddedInScroll = false,
    bool filterFeedOnTap = false,
  }) {
    final theme = Theme.of(context);
    final items = <Widget>[
      TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm dân tộc, vùng miền, chữ cổ...',
          hintStyle: TextStyle(
            fontSize: 13.5,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = cat == _selectedCategory;
            return ChoiceChip(
              label: Text(cat, style: const TextStyle(fontSize: 12)),
              visualDensity: VisualDensity.compact,
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedCategory = cat);
              },
            );
          },
        ),
      ),
      const SizedBox(height: 14),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF38120F), const Color(0xFF1E1E22)]
                : [const Color(0xFF8B261E), const Color(0xFF5E1712)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AC0D).withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4AC0D), width: 1),
              ),
              child: const Text(
                'TIÊU ĐIỂM DI SẢN',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFFE082),
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Dân tộc Chăm & Chữ Akhar Thrah',
              style: TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Hệ thống văn tự cổ nguồn gốc Brahmi được lưu truyền trên lá buông và bia đá ngàn năm.',
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF8B261E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
              ),
              onPressed: () {
                final cham = rows.firstWhere(
                  (r) => r.slug.contains('cham') || r.nameVi.contains('Chăm'),
                  orElse: () => rows.first,
                );
                context.go('/heritage/${cham.slug}');
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text(
                'Khám phá ngay',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      for (final script in _ancientScripts)
        Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            script['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${script['ethnic']} · ${script['family']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final match = rows.firstWhere(
                          (r) => r.slug.contains(script['slug']),
                          orElse: () => rows.first,
                        );
                        context.go('/heritage/${match.slug}');
                      },
                      child: const Text('Xem bảng chữ'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF161619)
                        : const Color(0xFFFBF8F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      script['glyphs'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 7,
                        color: script['color'] as Color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      Row(
        children: [
          Text(
            'Danh bạ ${rows.length} dân tộc & tiếng bản ngữ',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (filterFeedOnTap && _feedFilterSlug != 'all') ...[
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _feedFilterSlug = 'all'),
              child: const Text('Bỏ lọc feed'),
            ),
          ],
        ],
      ),
      const SizedBox(height: 10),
      for (final people in filteredRows) ...[
        _buildPeopleCard(
          context,
          people,
          locale,
          filterFeedOnTap: filterFeedOnTap,
        ),
        const SizedBox(height: 8),
      ],
    ];

    if (embeddedInScroll) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: items,
    );
  }

  Widget _buildPeopleCard(
    BuildContext context,
    People people,
    String locale, {
    bool filterFeedOnTap = false,
  }) {
    final theme = Theme.of(context);
    final name = locale == 'vi' ? people.nameVi : people.nameEn;
    final region = locale == 'vi' ? people.regionVi : people.regionEn;
    final cleanLabel = name.replaceFirst('Người ', '');
    final isFeedSelected = filterFeedOnTap && _feedFilterSlug == people.slug;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isFeedSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: isFeedSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => filterFeedOnTap
            ? setState(
                () => _feedFilterSlug =
                    _feedFilterSlug == people.slug ? 'all' : people.slug,
              )
            : context.go('/heritage/${people.slug}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                child: Text(
                  cleanLabel.isNotEmpty ? cleanLabel.characters.first : 'D',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${people.family} · $region',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Xem hồ sơ văn hóa',
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                onPressed: () => context.go('/heritage/${people.slug}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
