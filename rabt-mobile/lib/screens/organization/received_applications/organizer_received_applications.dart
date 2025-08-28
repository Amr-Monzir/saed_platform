import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/state/applications/applications_providers.dart';
import 'package:rabt_mobile/widgets/application_card.dart';
import 'package:rabt_mobile/widgets/application_detail_sheet.dart';

class OrganizerReceivedApplications extends ConsumerStatefulWidget {
  const OrganizerReceivedApplications({super.key});

  static const String path = '/o/received-applications';

  @override
  ConsumerState<OrganizerReceivedApplications> createState() => _OrganizerReceivedApplicationsState();
}

class _OrganizerReceivedApplicationsState extends ConsumerState<OrganizerReceivedApplications>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Received Applications'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: [
            _ApplicationCountTab(
              title: 'Pending',
              provider: pendingApplicationsProvider,
            ),
            _ApplicationCountTab(
              title: 'Accepted',
              provider: acceptedApplicationsProvider,
            ),
            _ApplicationCountTab(
              title: 'Rejected',
              provider: rejectedApplicationsProvider,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ApplicationsTab(provider: pendingApplicationsProvider),
          _ApplicationsTab(provider: acceptedApplicationsProvider),
          _ApplicationsTab(provider: rejectedApplicationsProvider),
        ],
      ),
    );
  }
}

class _ApplicationCountTab extends ConsumerWidget {
  const _ApplicationCountTab({
    required this.title,
    required this.provider,
  });

  final String title;
  final AutoDisposeAsyncNotifierProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(provider);

    return applicationsAsync.when(
      data: (data) {
        final count = data?.items.length ?? 0;
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              if (count > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => Tab(text: title),
      error: (_, __) => Tab(text: title),
    );
  }
}

class _ApplicationsTab extends ConsumerWidget {
  const _ApplicationsTab({required this.provider});

  final AutoDisposeAsyncNotifierProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(provider);

    return applicationsAsync.when(
      data: (data) {
        if (data == null || data.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(provider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200, // Account for AppBar and TabBar
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No applications yet',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Applications from volunteers will appear here',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(provider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.items.length,
            itemBuilder: (context, index) {
              final application = data.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ApplicationCard(
                  application: application,
                  onTap: () => ApplicationDetailSheet.showApplicationDetail(context, application),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(provider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: Center(child: Text('Error: $error')),
          ),
        ),
      ),
    );
  }
}
