import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/screens/adverts/advert_detail_screen.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/my_network_image.dart';

class OrganizerAdvertCard extends ConsumerWidget {
  const OrganizerAdvertCard({super.key, required this.advert});

  final Advert advert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      onTap: () => context.go(AdvertDetailScreen.orgFullPathFor(advert.id)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyNetworkImage(url: advert.advertImageUrl!),
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