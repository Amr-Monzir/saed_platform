import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/widgets/app_card.dart';
import 'package:rabt_mobile/widgets/app_button.dart';

class MyAdvertsScreen extends ConsumerWidget {
  const MyAdvertsScreen({super.key});

  static const String path = '/o/my-adverts';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(myAdvertsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Adverts')),
      body: mine.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) {
            final advert = items[i];
            return AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(advert.title, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('${advert.category} • ${advert.frequency.displayName} • ${advert.locationType.displayName}'),
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
    );
  }
}


