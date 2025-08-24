
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/state/applications/applications_repository.dart';

class OrganizerReceivedApplications extends ConsumerWidget {
  const OrganizerReceivedApplications({super.key});

  static const String path = '/o/received-applications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsRepositoryProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Received Applications')),
      body: const Center(child: Text('Received Applications')),
    );
  }
}