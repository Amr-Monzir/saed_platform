import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/organizer.dart';
import 'package:rabt_mobile/screens/organization/organizer_profile_screen.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/icon_tile.dart';
import 'package:rabt_mobile/widgets/my_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganizerCard extends StatelessWidget {
  const OrganizerCard({super.key, required this.organizer, required this.advertId});

  final OrganizerProfile organizer;
  final int? advertId;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.go(OrganizerProfileScreen.volunteerFullPathFor(advertId!, organizer.id)),
      child: Row(
        children: [
          if (organizer.logoUrl != null) ...[
            MyNetworkImage(url: organizer.logoUrl!, width: 48, height: 48),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              organizer.name,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (organizer.website != null) ...[
            const SizedBox(width: 5),
            IconTile(icon: Icons.language, onTap: () => launchUrl(Uri.parse(organizer.website!))),
          ],
        ],
      ),
    );
  }
}
