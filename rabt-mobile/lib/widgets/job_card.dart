import 'package:flutter/material.dart';
import '../models/advert.dart';
import 'badge_chip.dart';
import 'app_card.dart';
import 'icon_tile.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, this.onTap, this.trailing});
  final AdvertResponse job;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconTile(icon: Icons.work_outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Text(job.title, style: Theme.of(context).textTheme.titleMedium),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    BadgeChip(label: job.category, icon: Icons.category_outlined),
                    BadgeChip(label: job.frequency.name, icon: Icons.schedule_outlined),
                    BadgeChip(label: job.locationType.name, icon: Icons.place_outlined),
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


