import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';

import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

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
