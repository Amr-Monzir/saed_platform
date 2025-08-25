import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/state/applications/applications_providers.dart';
import 'package:rabt_mobile/widgets/application_card.dart';
import 'package:rabt_mobile/widgets/application_detail_sheet.dart';

class AdvertReceivedApplications extends ConsumerWidget {
  const AdvertReceivedApplications({super.key, required this.id});

  static String pathFor(int id) => '/o/adverts/$id/received-applications';
  static String pathTemplate = '/o/adverts/:id/received-applications';

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advertAsync = ref.watch(advertByIdProvider(id));
    if (!advertAsync.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final advert = advertAsync.value!;
    final applications = ref.watch(applicationsListProvider(advertId: id));

    return Scaffold(
      appBar: AppBar(title: Text('Advert applications for ${advert.title}')),
      body: applications.when(
        data:
            (data) =>
                data == null || data.items.isEmpty
                    ? const Center(child: Text('No applications yet'))
                    : ListView.separated(
                      itemCount: data.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final application = data.items[index];
                        return ApplicationCard(
                          application: application,
                          onTap: () => ApplicationDetailSheet.showApplicationDetail(context, application),
                        );
                      },
                    ),
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
