import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/screens/adverts/advert_detail_screen.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/widgets/app_card.dart';

class OrganizerAdvertCard extends ConsumerWidget {
  const OrganizerAdvertCard({super.key, required this.advert});

  final Advert advert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () => context.go(AdvertDetailScreen.orgFullPathFor(advert.id)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    '${ref.read(apiServiceProvider).baseUrl}${advert.advertImageUrl!}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.image, size: 48, color: theme.colorScheme.primary),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                Text(advert.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('${advert.category} • ${advert.frequency.displayName} • ${advert.locationType.displayName}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
