import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rabt_mobile/state/organizer/organizer_repository.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/icon_tile.dart';
import 'package:rabt_mobile/widgets/my_network_image.dart';

class OrganizerProfileScreen extends ConsumerWidget {
  const OrganizerProfileScreen({super.key, this.orgId, this.advertId});

  static const String organizerPathTemplate = '/o/profile';
  static const String volunteerPathTemplate = ':orgId/profile';

  static String volunteerFullPathFor(int advertId, int orgId) => '/v/adverts/$advertId/$orgId/profile';

  final int? orgId;
  final int? advertId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(authControllerProvider).value;
    final profileAsync = ref.watch(orgId == null ? organizerProfileProvider : publicOrganizerProfileProvider(orgId!));

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Organizer Profile'), elevation: 0),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Profile not found', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.error)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                AppCard(
                  child: Column(
                    children: [
                      // Logo/Profile Image
                      if (profile.logoUrl != null) ...[
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3), width: 2),
                          ),
                          child: ClipRRect(borderRadius: BorderRadius.circular(58), child: MyNetworkImage(url: profile.logoUrl!)),
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3), width: 2),
                          ),
                          child: Icon(Icons.business, size: 48, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Organization Name
                      Text(
                        profile.name,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      if (profile.description != null && profile.description!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          profile.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Contact Information
                if (profile.website != null && profile.website!.isNotEmpty) ...[
                  Text('Contact Information', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  AppCard(
                    onTap: () => _launchWebsite(profile.website!),
                    child: Row(
                      children: [
                        const IconTile(icon: Icons.language),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Website', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                profile.website!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.open_in_new, color: theme.colorScheme.primary, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Organization Details
                Text('Organization Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                AppCard(child: _buildDetailRow(context, 'Description', profile.description!, Icons.description)),

                const SizedBox(height: 24),

                if (session.userType == UserType.organizer) ...[
                  // Actions
                  Text('Actions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  AppCard(
                    onTap: () {
                      // TODO: Implement edit profile functionality
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit profile coming soon...')));
                    },
                    child: Row(
                      children: [
                        const IconTile(icon: Icons.edit),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Edit Profile', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onSurface.withValues(alpha: 0.5), size: 16),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Error loading profile', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.error)),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWebsite(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Handle error - could show a snackbar here
    }
  }
}
