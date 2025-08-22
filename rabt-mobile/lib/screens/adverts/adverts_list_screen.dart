import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'package:rabt_mobile/widgets/advert_card.dart';
import 'package:rabt_mobile/state/applications/applications_repository.dart';
import 'adverts_filters_sheet.dart';
import 'adverts_detail_screen.dart';
import '../auth/signup_screen.dart';

class AdvertsListScreen extends ConsumerWidget {
  const AdvertsListScreen({super.key});

  static const String volunteerPath = '/v/adverts';
  static const String guestPath = '/adverts';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advertsAsync = ref.watch(filteredAdvertsProvider);
    final searchCtrl = TextEditingController(text: ref.watch(searchQueryProvider) ?? '');
    return Scaffold(
      appBar: AppBar(title: const Text('Activist Adverts')),
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
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
                  final advert = page.items[index];
                  return AdvertCard(
                    advert: advert,
                    onTap: () => context.push(AdvertsDetailScreen.pathFor(advert.id)),
                    trailing: AppButton(
                      onPressed: () async {
                        final session = ref.read(authControllerProvider).session;
                        if (session == null) {
                          await ref.read(authControllerProvider.notifier).setPendingAdvert(advert.id.toString());
                          if (!context.mounted) return;
                          context.push(SignupScreen.path);
                          return;
                        }
                        
                        // Use state notifier for application creation
                        await ref.read(createApplicationControllerProvider.notifier).createApplication(
                          advertId: advert.id,
                        );
                        
                        if (!context.mounted) return;
                        
                        // Check if application was successful
                        final applicationState = ref.read(createApplicationControllerProvider);
                        if (applicationState.hasError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Application failed: ${applicationState.error}')),
                          );
                        } else if (applicationState.value != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Application submitted')),
                          );
                          // Reset the state
                          ref.read(createApplicationControllerProvider.notifier).reset();
                        }
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


