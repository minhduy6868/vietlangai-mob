import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

class HeritageListView extends ConsumerStatefulWidget {
  const HeritageListView({super.key});

  @override
  ConsumerState<HeritageListView> createState() => _HeritageListViewState();
}

class _HeritageListViewState extends ConsumerState<HeritageListView> {
  String _selectedCategory = 'Tất cả';
  final _searchController = TextEditingController();

  // Categories follow the five peoples in shared/languages.json only.
  final List<String> _categories = [
    'Tất cả',
    'Tày',
    'Ê Đê',
    'Chăm',
    'H\'Mông',
    'Jrai',
  ];

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

    return peoplesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (rows) {
        if (rows.isEmpty) return Center(child: Text(l10n.emptyPeoples));

        // Filter based on search and category
        final filteredRows = rows.where((people) {
          final title = (locale == 'vi' ? people.nameVi : people.nameEn).toLowerCase();
          final matchesSearch = _searchController.text.isEmpty ||
              title.contains(_searchController.text.toLowerCase());
          final matchesCategory = _selectedCategory == 'Tất cả' ||
              title.contains(_selectedCategory.toLowerCase());
          return matchesSearch && matchesCategory;
        }).toList();

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 1. Search Bar
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm chữ cổ, văn hóa, ngữ hệ...',
                hintStyle: TextStyle(
                  fontSize: 14,
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Filter Chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: theme.colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.15),
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 3. Featured Hero Card (Dân tộc Chăm & Chữ Akhar Thrah)
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
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B261E).withValues(alpha: isDark ? 0.3 : 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 12),
                  const Text(
                    'Dân tộc Chăm & Chữ Akhar Thrah',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hệ thống văn tự cổ của người Chăm có nguồn gốc từ chữ Brahmi Ấn Độ, được khắc trên bia đá và lưu truyền qua ngàn năm.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF8B261E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 4. Section: Ký tự cổ & Ngữ hệ
            Row(
              children: [
                Text(
                  'Ký tự cổ & Ngữ hệ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                Text(
                  '2 hệ thống chữ',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Cards for Ancient Scripts
            for (final script in _ancientScripts)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${script['ethnic']} • ${script['family']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (script['color'] as Color).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              script['count'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: script['color'] as Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF161619) : const Color(0xFFFBF8F3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF28282C) : const Color(0xFFEFE9E0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            script['glyphs'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 8,
                              color: script['color'] as Color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            final match = rows.firstWhere(
                              (r) => r.slug.contains(script['slug']) || r.nameVi.contains(script['slug']),
                              orElse: () => rows.first,
                            );
                            context.go('/heritage/${match.slug}');
                          },
                          icon: const Icon(Icons.menu_book_rounded, size: 16),
                          label: const Text('Xem bảng chữ', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // 5. Danh mục các dân tộc
            Text(
              'Danh bạ dân tộc & tiếng bản ngữ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 10),

            for (final people in filteredRows)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                    child: Text(
                      people.nameVi.isNotEmpty ? people.nameVi.substring(0, 1) : 'D',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  title: Text(
                    locale == 'vi' ? people.nameVi : people.nameEn,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  subtitle: Text(
                    '${people.family} • ${locale == 'vi' ? people.regionVi : people.regionEn}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => context.go('/heritage/${people.slug}'),
                ),
              ),
          ],
        );
      },
    );
  }
}

class HeritageDetailView extends ConsumerWidget {
  const HeritageDetailView({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final peoples = ref.watch(peoplesProvider);
    final heritage = ref.watch(heritageProvider(slug));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết di sản'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: peoples.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (rows) {
          People? people;
          for (final row in rows) {
            if (row.slug == slug) {
              people = row;
              break;
            }
          }
          if (people == null) return Center(child: Text(l10n.emptyPeoples));
          final items = heritage.asData?.value ?? const [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              people.family,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            locale == 'vi' ? people.regionVi : people.regionEn,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        locale == 'vi' ? people.nameVi : people.nameEn,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.origin,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        (locale == 'vi' ? people.originVi : people.originEn) ??
                            'Dân tộc có bề dày lịch sử và di sản ngôn ngữ độc đáo tại Việt Nam.',
                        style: const TextStyle(fontSize: 13.5, height: 1.45),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tư liệu di sản & văn hóa',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Tư liệu đang được đồng bộ và cập nhật từ các chuyên gia ngôn ngữ học.'),
                  ),
                )
              else
                for (final item in items)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale == 'vi' ? item.titleVi : item.titleEn,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            locale == 'vi' ? item.bodyVi : item.bodyEn,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                          if (item.mediaUrl != null) ...[
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.grey.shade200,
                                height: 120,
                                width: double.infinity,
                                child: const Center(
                                  child: Icon(Icons.image_outlined, size: 36, color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
