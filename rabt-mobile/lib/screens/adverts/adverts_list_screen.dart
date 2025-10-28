import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/screens/adverts/advert_detail_screen.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/screens/adverts/volunteer_advert_card.dart';
import 'adverts_filters_sheet.dart';

class AdvertsListScreen extends ConsumerWidget {
  const AdvertsListScreen({super.key});

  static const String volunteerPath = '/v/adverts';
  static const String guestPath = '/adverts';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advertsAsync = ref.watch(advertsProvider);
    final searchCtrl = TextEditingController(text: ref.watch(searchQueryProvider) ?? '');
    return Scaffold(
      appBar: ref.watch(authControllerProvider).value == null ? null : AppBar(title: const Text('Activist Adverts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    decoration: const InputDecoration(hintText: 'Search'),
                    onSubmitted: (v) => ref.read(searchQueryProvider.notifier).state = v.trim(),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                      builder: (_) => const AdvertsFiltersSheet(),
                    );
                  },
                  icon: const Icon(Icons.tune_outlined),
                  label: const Text('Filters'),
                ),
              ],
            ),
          ),
          Expanded(
            child: advertsAsync.when(
              data:
                  (page) => ListView.builder(
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
                                variant: AppButtonVariant.inline,
                                label: 'Prev',
                                onPressed: current > 1 ? () => ref.read(pageProvider.notifier).state = current - 1 : null,
                              ),
                              Text('Page $current of ${page.totalPages}'),
                              AppButton(
                                label: 'Next',
                                onPressed:
                                    current < page.totalPages ? () => ref.read(pageProvider.notifier).state = current + 1 : null,
                              ),
                            ],
                          ),
                        );
                      }
                      final advert = page.items[index];
                      return VolunteerAdvertCard(
                        advert: advert,
                        onTap:
                            () => context.go(
                              ref.read(authControllerProvider).value?.userType == UserType.volunteer
                                  ? AdvertDetailScreen.volunteerFullPathFor(advert.id)
                                  : AdvertDetailScreen.guestFullPathFor(advert.id),
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
