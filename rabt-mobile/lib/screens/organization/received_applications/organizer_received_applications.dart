import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/state/applications/applications_providers.dart';
import 'package:rabt_mobile/widgets/application_card.dart';
import 'package:rabt_mobile/widgets/application_detail_sheet.dart';

class OrganizerReceivedApplications extends ConsumerWidget {
  const OrganizerReceivedApplications({super.key});

  static const String path = '/o/received-applications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsListProvider());

    return Scaffold(
      appBar: AppBar(title: const Text('Received Applications'), elevation: 0),
      body: applications.when(
        data:
            (data) =>
                data == null || data.items.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No applications yet',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Applications from volunteers will appear here',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: data.items.length,
                      itemBuilder: (context, index) {
                        final application = data.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ApplicationCard(
                            application: application,
                            onTap: () => ApplicationDetailSheet.showApplicationDetail(context, application),
                          ),
                        );
                      },
                    ),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.6)),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading applications',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
