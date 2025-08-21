import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/screens/auth/signup_screen.dart';
import 'package:rabt_mobile/state/adverts/adverts_repository.dart';
import 'package:rabt_mobile/state/applications/applications_repository.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/icon_tile.dart';

class AdvertsDetailScreen extends ConsumerWidget {
  const AdvertsDetailScreen({super.key, required this.id});
  final int id;

  static const String guestPathTemplate = '/adverts/:id';
  static String pathFor(int id) => '/adverts/$id';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(advertsRepositoryProvider);
    return FutureBuilder<Advert?>(
      future: repo.getById(id),
      builder: (context, snapshot) {
        final advert = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: const Text('Advert details')),
          body: snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : advert == null
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
                                    Text(advert.title, style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 6),
                                    Text('${advert.category} • ${advert.frequency.name} • ${advert.locationType.name}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (advert.requiredSkills.isNotEmpty)
                          AppCard(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: advert.requiredSkills.map((s) => Chip(label: Text(s.name))).toList(),
                            ),
                          ),
                        if (advert.oneoffDetails != null)
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('One-off', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                Text('Event: ${advert.oneoffDetails!.eventDatetime}'),
                                Text('Time: ${advert.oneoffDetails!.timeCommitment.name}'),
                                Text('Apply by: ${advert.oneoffDetails!.applicationDeadline}'),
                              ],
                            ),
                          ),
                        if (advert.recurringDetails != null)
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Recurring', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                Text('Every: ${advert.recurringDetails!.recurrence.name}'),
                                Text('Per session: ${advert.recurringDetails!.timeCommitmentPerSession.name}'),
                                Text('Duration: ${advert.recurringDetails!.duration.name}'),
                              ],
                            ),
                          ),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('About this opportunity', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(advert.description),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          label: 'Apply',
                          onPressed: () async {
                            final session = ref.read(authControllerProvider).session;
                            if (session == null) {
                              context.push(SignupScreen.path);
                              return;
                            }
                            final appRepo = ref.read(applicationsRepositoryProvider);
                            await appRepo.create(advertId: advert.id);
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


