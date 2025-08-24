import 'package:flutter/material.dart';
import '../models/advert.dart';
import 'badge_chip.dart';
import 'app_card.dart';
import 'icon_tile.dart';

class AdvertCard extends StatelessWidget {
  const AdvertCard({super.key, required this.advert, this.onTap, this.trailing});
  final Advert advert;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconTile(icon: Icons.work_outline),
          const SizedBox(width: 12),
          Expanded(
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
          const SizedBox(width: 12),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}


