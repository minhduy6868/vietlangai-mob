import 'package:flutter/material.dart';
import 'package:ngon_sac_viet/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/models/models.dart';
import '../../../app_providers.dart';
import '../../settings/view_models/settings_view_model.dart';

class HeritageListView extends ConsumerWidget {
  const HeritageListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final peoples = ref.watch(peoplesProvider);
    return peoples.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (rows) {
        if (rows.isEmpty) return Center(child: Text(l10n.emptyPeoples));
        return ListView.separated(
          itemCount: rows.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final people = rows[index];
            final title = locale == 'vi' ? people.nameVi : people.nameEn;
            final region = locale == 'vi' ? people.regionVi : people.regionEn;
            return ListTile(
              title: Text(title),
              subtitle: Text(region),
              onTap: () => context.go('/heritage/${people.slug}'),
            );
          },
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
    final locale = ref.watch(settingsViewModelProvider).locale.languageCode;
    final peoples = ref.watch(peoplesProvider);
    final heritage = ref.watch(heritageProvider(slug));
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: peoples.when(
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
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(onPressed: () => context.pop()),
              ),
              Text(
                locale == 'vi' ? people.nameVi : people.nameEn,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('${l10n.languageFamily}: ${people.family}'),
              const SizedBox(height: 8),
              Text(
                '${l10n.region}: ${locale == 'vi' ? people.regionVi : people.regionEn}',
              ),
              const SizedBox(height: 12),
              Text(l10n.origin, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                locale == 'vi' ? people.originVi ?? '' : people.originEn ?? '',
              ),
              const SizedBox(height: 16),
              for (final item in items) ...[
                Text(
                  locale == 'vi' ? item.titleVi : item.titleEn,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(locale == 'vi' ? item.bodyVi : item.bodyEn),
                if (item.mediaUrl != null) Text(item.mediaUrl!),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );
  }
}
