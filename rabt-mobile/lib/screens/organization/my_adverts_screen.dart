import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import 'create_advert_wizard.dart';

class MyAdvertsScreen extends ConsumerStatefulWidget {
  const MyAdvertsScreen({super.key});

  static const String path = '/o/my-adverts';

  @override
  ConsumerState<MyAdvertsScreen> createState() => _MyAdvertsScreenState();
}

class _MyAdvertsScreenState extends ConsumerState<MyAdvertsScreen> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: ref.read(myAdvertsSearchControllerProvider) ?? '');
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mine = ref.watch(filteredMyAdvertsProvider);
    final query = ref.watch(myAdvertsSearchControllerProvider) ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('My Adverts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(CreateAdvertWizard.path),
        child: const Icon(Icons.add),
        tooltip: 'Create Advert',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search my adverts',
                prefixIcon: Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref.read(myAdvertsSearchControllerProvider.notifier).clear();
                          FocusScope.of(context).unfocus();
                        },
                      ),
              ),
              onChanged: (v) {
                ref.read(myAdvertsSearchControllerProvider.notifier).setQuery(v);
              },
              onSubmitted: (v) => ref.read(myAdvertsSearchControllerProvider.notifier).setQuery(v),
            ),
          ),
          Expanded(
            child: mine.when(
              data:
                  (page) => ListView.builder(
                    itemCount: page.items.length,
                    itemBuilder: (context, i) {
                      final advert = page.items[i];
                      return AppCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(advert.title, style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${advert.category} • ${advert.frequency.displayName} • ${advert.locationType.displayName}',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            AppButton(label: 'Close', variant: AppButtonVariant.outline, onPressed: () {}),
                          ],
                        ),
                      );
                    },
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
            ),
          ),
        ],
      ),
    );
  }
}
