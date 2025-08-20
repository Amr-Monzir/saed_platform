import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/advert.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/icon_tile.dart';
import '../../state/auth/auth_providers.dart';
import '../../state/jobs/jobs_repository.dart';
import '../../state/applications/applications_repository.dart';

class JobDetailScreen extends ConsumerWidget {
  const JobDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(advertsRepositoryProvider);
    return FutureBuilder<AdvertResponse?>(
      future: repo.getById(id),
      builder: (context, snapshot) {
        final job = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: const Text('Job details')),
          body: snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : job == null
                  ? const Center(child: Text('Not found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        AppCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const IconTile(icon: Icons.work_outline),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(job.title, style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 6),
                                    Text('${job.category} • ${job.frequency.name} • ${job.locationType.name}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (job.requiredSkills.isNotEmpty)
                          AppCard(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: job.requiredSkills.map((s) => Chip(label: Text(s.name))).toList(),
                            ),
                          ),
                        if (job.oneoffDetails != null)
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('One-off', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                Text('Event: ${job.oneoffDetails!.eventDatetime}'),
                                Text('Time: ${job.oneoffDetails!.timeCommitment.name}'),
                                Text('Apply by: ${job.oneoffDetails!.applicationDeadline}'),
                              ],
                            ),
                          ),
                        if (job.recurringDetails != null)
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Recurring', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                Text('Every: ${job.recurringDetails!.recurrence.name}'),
                                Text('Per session: ${job.recurringDetails!.timeCommitmentPerSession.name}'),
                                Text('Duration: ${job.recurringDetails!.duration.name}'),
                              ],
                            ),
                          ),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('About this opportunity', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(job.description),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          label: 'Apply',
                          onPressed: () async {
                            final session = ref.read(authControllerProvider).session;
                            if (session == null) {
                              context.push('/signup');
                              return;
                            }
                            final appRepo = ref.read(applicationsRepositoryProvider);
                            await appRepo.create(advertId: job.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Application submitted')),
                            );
                          },
                        ),
                      ],
                    ),
        );
      },
    );
  }
}


