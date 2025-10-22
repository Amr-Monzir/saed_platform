import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/screens/auth/signup_volunteer_screen.dart';
import 'package:rabt_mobile/screens/organization/received_applications/advert_received_applications.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/state/applications/applications_providers.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/icon_tile.dart';
import 'package:rabt_mobile/widgets/my_network_image.dart';
import 'package:rabt_mobile/widgets/organizer_card.dart';

// State provider for schedule expansion
final _scheduleExpandedProvider = StateProvider<bool>((ref) => false);

// Helper function to capitalize day names
String _capitalizeDayName(String day) {
  if (day.isEmpty) return day;
  return day[0].toUpperCase() + day.substring(1).toLowerCase();
}

class AdvertDetailScreen extends ConsumerWidget {
  const AdvertDetailScreen({super.key, required this.id});

  static const String pathTemplate = ':id';
  static String guestFullPathFor(int id) => '/adverts/$id';
  static String volunteerFullPathFor(int id) => '/v/adverts/$id';
  static String orgFullPathFor(int id) => '/o/my-adverts/$id';

  final int id;

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
                            if (advert.imageUrl != null) MyNetworkImage(url: advert.imageUrl!),
                            const SizedBox(height: 12),
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
                            AppCard(
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16, top: 16),
                                    child: Text('Organizer', style: Theme.of(context).textTheme.titleMedium),
                                  ),
                                  const SizedBox(height: 8),
                                  OrganizerCard(organizer: advert.organizer, advertId: advert.id),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                            if (advert.requiredSkills.isNotEmpty)
                              AppCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Required skills', style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: advert.requiredSkills.map((s) => Chip(label: Text(s.name))).toList(),
                                    ),
                                  ],
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
                              Consumer(
                                builder: (context, ref, child) {
                                  final isExpanded = ref.watch(_scheduleExpandedProvider);
                                  return AppCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Recurring', style: Theme.of(context).textTheme.titleMedium),
                                        const SizedBox(height: 8),
                                        Text('Every: ${advert.recurringDetails!.recurrence.displayName}'),
                                        Text('Per session: ${advert.recurringDetails!.timeCommitmentPerSession.displayName}'),
                                        Text('Duration: ${advert.recurringDetails!.duration.displayName}'),

                                        // Show expandable schedule if specific days exist
                                        if (advert.recurringDetails!.specificDays.isNotEmpty) ...[
                                          const SizedBox(height: 12),
                                          InkWell(
                                            onTap: () {
                                              ref.read(_scheduleExpandedProvider.notifier).update((state) => !state);
                                            },
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'View Schedule',
                                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).colorScheme.primary,
                                                    ),
                                                  ),
                                                  AnimatedRotation(
                                                    turns: isExpanded ? 0.5 : 0,
                                                    duration: const Duration(milliseconds: 200),
                                                    child: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Theme.of(context).colorScheme.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            height: isExpanded ? null : 0,
                                            child:
                                                isExpanded
                                                    ? Column(
                                                      children: [
                                                        const SizedBox(height: 12),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  'Day',
                                                                  style: Theme.of(
                                                                    context,
                                                                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'Time Periods',
                                                                  style: Theme.of(
                                                                    context,
                                                                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        // Schedule rows
                                                        ...advert.recurringDetails!.specificDays.map((dayInfo) {
                                                          final periods = dayInfo.periods.toList();
                                                          periods.sort((a, b) => a.index.compareTo(b.index));
                                                          return Container(
                                                            margin: const EdgeInsets.only(bottom: 4),
                                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                context,
                                                              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                                                              borderRadius: BorderRadius.circular(6),
                                                              border: Border.all(
                                                                color: Theme.of(
                                                                  context,
                                                                ).colorScheme.outline.withValues(alpha: 0.1),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Text(
                                                                    _capitalizeDayName(dayInfo.day),
                                                                    style: Theme.of(
                                                                      context,
                                                                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child:
                                                                      periods.isNotEmpty
                                                                          ? Wrap(
                                                                            spacing: 6,
                                                                            runSpacing: 4,
                                                                            children:
                                                                                periods.map((period) {
                                                                                  return Container(
                                                                                    padding: const EdgeInsets.symmetric(
                                                                                      horizontal: 8,
                                                                                      vertical: 3,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      color: Theme.of(context).colorScheme.primary
                                                                                          .withValues(alpha: 0.1),
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      border: Border.all(
                                                                                        color: Theme.of(context)
                                                                                            .colorScheme
                                                                                            .primary
                                                                                            .withValues(alpha: 0.3),
                                                                                      ),
                                                                                    ),
                                                                                    child: Text(
                                                                                      period.displayName,
                                                                                      style: Theme.of(
                                                                                        context,
                                                                                      ).textTheme.bodySmall?.copyWith(
                                                                                        color:
                                                                                            Theme.of(context).colorScheme.primary,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }).toList(),
                                                                          )
                                                                          : Text(
                                                                            'No specific times',
                                                                            style: Theme.of(
                                                                              context,
                                                                            ).textTheme.bodySmall?.copyWith(
                                                                              color:
                                                                                  Theme.of(context).colorScheme.onSurfaceVariant,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                      ],
                                                    )
                                                    : null,
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
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
                                    context.push(SignupVolunteerScreen.path);
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
                                    onPressed: () => context.go(AdvertReceivedApplications.fullPathFor(advert.id)),
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
                                              context.push(SignupVolunteerScreen.path);
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
