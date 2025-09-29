import 'package:flutter/material.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/badge_chip.dart';
import 'package:rabt_mobile/widgets/my_network_image.dart';

class VolunteerAdvertCard extends StatelessWidget {
  const VolunteerAdvertCard({super.key, required this.advert, this.onTap});
  final Advert advert;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          if (advert.imageUrl != null) MyNetworkImage(url: advert.imageUrl!, height: 200, width: double.infinity),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(advert.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    BadgeChip(label: advert.category, icon: Icons.category_outlined),
                    BadgeChip(label: advert.frequency.displayName, icon: Icons.schedule_outlined),
                    BadgeChip(label: advert.locationType.displayName, icon: Icons.place_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
