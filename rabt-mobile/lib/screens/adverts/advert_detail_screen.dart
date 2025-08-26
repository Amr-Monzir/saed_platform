import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/screens/auth/signup_screen.dart';
import 'package:rabt_mobile/screens/organization/received_applications/advert_received_applications.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/state/applications/applications_providers.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/icon_tile.dart';

class AdvertDetailScreen extends ConsumerWidget {
  const AdvertDetailScreen({super.key, required this.id});
  final int id;

  static const String pathTemplate = '/adverts/:id';
  static const String pathTemplateOrg = '/o/adverts/:id';
  static String pathFor(int id) => '/adverts/$id';
  static String pathForOrg(int id) => '/o/adverts/$id';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authControllerProvider).value?.userType;
    return ref
        .watch(advertByIdProvider(id))
        .when(
          data:
              (advert) =>
                  advert == null
                      ? Scaffold(
                        appBar: AppBar(title: const Text('Advert details')),
                        body: const Center(child: Text('Advert not found')),
                      )
                      : Scaffold(
                        appBar: AppBar(title: const Text('Advert details')),
                        body: ListView(
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
                                        Text(
                                          '${advert.category} • ${advert.frequency.displayName} • ${advert.locationType.displayName}',
                                        ),
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
                                    Text('Every: ${advert.recurringDetails!.recurrence.displayName}'),
                                    Text('Per session: ${advert.recurringDetails!.timeCommitmentPerSession.displayName}'),
                                    Text('Duration: ${advert.recurringDetails!.duration.displayName}'),
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
                            if (role == UserType.volunteer)
                              AppButton(
                                label: 'Apply',
                                onPressed: () async {
                                  final session = ref.read(authControllerProvider).value;
                                  if (session == null) {
                                    context.push(SignupScreen.path);
                                    return;
                                  }
                                  await ref
                                      .read(createApplicationControllerProvider.notifier)
                                      .createApplication(advertId: advert.id);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application submitted')));
                                },
                              ),
                            if (role == UserType.organizer)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 12),
                                  AppButton(
                                    label: 'View applications',
                                    variant: AppButtonVariant.outline,
                                    onPressed: () => context.go(AdvertReceivedApplications.pathFor(advert.id)),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                          label: 'Edit',
                                          onPressed: () async {
                                            // TODO: Implement edit functionality
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AppButton(
                                          label: 'Close',
                                          variant: AppButtonVariant.outline,
                                          onPressed: () async {
                                            final session = ref.read(authControllerProvider).value;
                                            if (session == null) {
                                              context.push(SignupScreen.path);
                                              return;
                                            }
                                            await ref.read(closeAdvertControllerProvider.notifier).closeAdvert(advert.id);
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Advert closed')));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error:
              (error, stack) =>
                  Scaffold(appBar: AppBar(title: const Text('Advert details')), body: Center(child: Text('Error: $error'))),
        );
  }
}
