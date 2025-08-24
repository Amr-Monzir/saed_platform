import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/state/applications/applications_providers.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';

class OrganizerReceivedApplications extends ConsumerWidget {
  const OrganizerReceivedApplications({super.key});

  static const String path = '/o/received-applications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(
      applicationsListProvider(organizerId: ref.watch(authControllerProvider).value?.organizerProfile?.id.toString()),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Received Applications')),
      body: applications.when(
        data:
            (data) =>
                data == null
                    ? const Center(child: Text('No applications found'))
                    : ListView.builder(
                      itemCount: data.items.length,
                      itemBuilder: (context, index) => Text(data.items[index].toString()),
                    ),
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
