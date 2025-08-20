import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/jobs/jobs_providers.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';

class MyJobsScreen extends ConsumerWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(myJobsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Jobs')),
      body: mine.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) {
            final job = items[i];
            return AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.title, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('${job.category} • ${job.frequency}'),
                      ],
                    ),
                  ),
                  AppButton(label: 'Close', variant: AppButtonVariant.outline, onPressed: () {}),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}


