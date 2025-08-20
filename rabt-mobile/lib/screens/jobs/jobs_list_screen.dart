import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/jobs/jobs_providers.dart';
import '../../state/auth/auth_providers.dart';
import 'jobs_filters_bar.dart';
import '../../widgets/app_button.dart';
import '../../state/applications/applications_repository.dart';
import '../../widgets/job_card.dart';

class JobsListScreen extends ConsumerWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(filteredJobsProvider);
    final searchCtrl = TextEditingController(text: ref.watch(searchQueryProvider) ?? '');
    return Scaffold(
      appBar: AppBar(title: const Text('Activist Jobs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchCtrl,
              decoration: const InputDecoration(hintText: 'Search'),
              onSubmitted: (v) => ref.read(searchQueryProvider.notifier).state = v.trim(),
            ),
          ),
          const JobsFiltersBar(),
          Expanded(
            child: jobsAsync.when(
              data: (page) => ListView.builder(
                itemCount: page.items.length + 1,
                itemBuilder: (context, index) {
                  if (index == page.items.length) {
                    final current = ref.read(pageProvider);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton(
                            label: 'Prev',
                            variant: AppButtonVariant.outline,
                            onPressed: current > 1
                                ? () => ref.read(pageProvider.notifier).state = current - 1
                                : null,
                          ),
                          Text('Page $current of ${page.totalPages}'),
                          AppButton(
                            label: 'Next',
                            onPressed: current < page.totalPages
                                ? () => ref.read(pageProvider.notifier).state = current + 1
                                : null,
                          ),
                        ],
                      ),
                    );
                  }
                  final job = page.items[index];
                  return JobCard(
                    job: job,
                    onTap: () => context.go('/jobs/${job.id}'),
                    trailing: AppButton(
                      onPressed: () async {
                        final session = ref.read(authControllerProvider).session;
                        if (session == null) {
                          await ref.read(authControllerProvider.notifier).setPendingAdvert(job.id.toString());
                          if (!context.mounted) return;
                          context.go('/signup');
                          return;
                        }
                        await ref.read(applicationsRepositoryProvider).create(advertId: job.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Application submitted')),
                        );
                      },
                      label: 'Apply',
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}


