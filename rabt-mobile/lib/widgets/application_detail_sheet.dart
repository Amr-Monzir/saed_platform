import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/application.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/applications/applications_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/badge_chip.dart';

class ApplicationDetailSheet extends ConsumerStatefulWidget {
  const ApplicationDetailSheet({super.key, required this.application});

  final Application application;

  @override
  ConsumerState<ApplicationDetailSheet> createState() => _ApplicationDetailSheetState();
}

class _ApplicationDetailSheetState extends ConsumerState<ApplicationDetailSheet> {
  String? _organizerMessage;
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final application = widget.application;
    final volunteer = application.volunteer;
    final advert = application.advert;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with volunteer info and status
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          (volunteer?.name ?? 'A').substring(0, 1).toUpperCase(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              volunteer?.name ?? 'Anonymous Volunteer',
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (volunteer?.city != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                                  const SizedBox(width: 4),
                                  Text(
                                    volunteer!.city!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      BadgeChip(label: application.status.displayName, color: _getStatusColor(application.status)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Application details
                  _buildSection(
                    title: 'Application Details',
                    children: [
                      _buildDetailRow('Applied', _formatDate(application.appliedAt)),
                      _buildDetailRow('Status', application.status.displayName),
                      if (application.coverMessage != null && application.coverMessage!.isNotEmpty)
                        _buildDetailRow('Cover Message', application.coverMessage!),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Volunteer details
                  if (volunteer != null) ...[
                    _buildSection(
                      title: 'Volunteer Information',
                      children: [
                        _buildDetailRow('Name', volunteer.name),
                        if (volunteer.phoneNumber != null) _buildDetailRow('Phone', volunteer.phoneNumber!),
                        if (volunteer.city != null) _buildDetailRow('City', volunteer.city!),
                        if (volunteer.country != null) _buildDetailRow('Country', volunteer.country!),
                        if (volunteer.skills.isNotEmpty)
                          _buildDetailRow('Skills', volunteer.skills.map((s) => s.name).join(', ')),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Advert details
                  _buildSection(
                    title: 'Opportunity Details',
                    children: [
                      _buildDetailRow('Title', advert.title),
                      _buildDetailRow('Category', advert.category),
                      _buildDetailRow('Frequency', advert.frequency.displayName),
                      _buildDetailRow('Location Type', advert.locationType.displayName),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action buttons (only for pending applications  )
                  if (application.status == ApplicationStatus.pending) ...[

                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Accept',
                            onPressed: _isUpdating ? null : () => _updateStatus(ApplicationStatus.accepted),
                            variant: AppButtonVariant.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: 'Reject',
                            onPressed: _isUpdating ? null : () => _updateStatus(ApplicationStatus.rejected),
                            variant: AppButtonVariant.outline,
                          ),
                        ),
                      ],
                    ),
                  ] else if (application.status == ApplicationStatus.accepted) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Application accepted',
                              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (application.status == ApplicationStatus.rejected) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.cancel, color: Colors.red, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Application rejected',
                              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: .3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: .7),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.withdrawn:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _updateStatus(ApplicationStatus status) async {
    setState(() => _isUpdating = true);

    try {
      await ref
          .read(updateApplicationStatusControllerProvider.notifier)
          .updateStatus(
            widget.application.id,
            status,
            organizerMessage: _organizerMessage?.isNotEmpty == true ? _organizerMessage : null,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application ${status.displayName.toLowerCase()}'), backgroundColor: _getStatusColor(status)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}
