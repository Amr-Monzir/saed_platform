import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/application.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/applications/applications_repository.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/util/parse_helpers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'applications_providers.g.dart';

@riverpod
class ApplicationsList extends _$ApplicationsList {
  @override
  Future<PaginatedResponse<Application>?> build() async {
    final session = ref.watch(authControllerProvider).value;
    if (session?.userType != UserType.organizer) {
      return null;
    }

    final repository = ref.watch(applicationsRepositoryProvider);
    return repository.fetchOrganizerApplications();
  }

  Future<PaginatedResponse<Application>?> fetchApplications({int? advertId, int? page, int? limit, ApplicationStatus? status}) async {
    final repository = ref.watch(applicationsRepositoryProvider);
    return repository.fetchOrganizerApplications(advertId: advertId, page: page, limit: limit, status: status);
  }

  Future<void> acceptApplication(int id, String? organizerMessage) async {
    final repository = ref.watch(applicationsRepositoryProvider);
    await repository.updateStatus(id, ApplicationStatus.accepted, organizerMessage: organizerMessage);
    ref.invalidateSelf();
    // Refresh status-specific providers
    ref.invalidate(pendingApplicationsProvider);
    ref.invalidate(acceptedApplicationsProvider);
    ref.invalidate(rejectedApplicationsProvider);
  }

  Future<void> rejectApplication(int id, String? organizerMessage) async {
    final repository = ref.watch(applicationsRepositoryProvider);
    await repository.updateStatus(id, ApplicationStatus.rejected, organizerMessage: organizerMessage);
    ref.invalidateSelf();
    // Refresh status-specific providers
    ref.invalidate(pendingApplicationsProvider);
    ref.invalidate(acceptedApplicationsProvider);
    ref.invalidate(rejectedApplicationsProvider);
  }
}

class CreateApplicationController extends StateNotifier<AsyncValue<Application?>> {
  CreateApplicationController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> createApplication({required int advertId, String? coverMessage}) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(applicationsRepositoryProvider);
      final result = await repository.create(advertId: advertId, coverMessage: coverMessage);
      state = AsyncValue.data(result);

      // Invalidate the applications list to refresh it
      ref.invalidate(applicationsListProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final createApplicationControllerProvider = StateNotifierProvider<CreateApplicationController, AsyncValue<Application?>>((ref) {
  return CreateApplicationController(ref);
});

class UpdateApplicationStatusController extends StateNotifier<AsyncValue<Application?>> {
  UpdateApplicationStatusController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> updateStatus(int id, ApplicationStatus status, {String? organizerMessage}) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(applicationsRepositoryProvider);
      final result = await repository.updateStatus(id, status, organizerMessage: organizerMessage);
      state = AsyncValue.data(result);

      // Invalidate the applications list to refresh it
      ref.invalidate(applicationsListProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final updateApplicationStatusControllerProvider =
    StateNotifierProvider<UpdateApplicationStatusController, AsyncValue<Application?>>((ref) {
      return UpdateApplicationStatusController(ref);
    });

@riverpod
class PendingApplications extends _$PendingApplications {
  @override
  Future<PaginatedResponse<Application>?> build() async {
    final session = ref.watch(authControllerProvider).value;
    if (session?.userType != UserType.organizer) {
      return null;
    }

    final repository = ref.watch(applicationsRepositoryProvider);
    return repository.fetchOrganizerApplications(status: ApplicationStatus.pending);
  }

  Future<PaginatedResponse<Application>?> fetchApplications({int? page, int? limit}) async {
    final repository = ref.watch(applicationsRepositoryProvider);
    return repository.fetchOrganizerApplications(page: page, limit: limit, status: ApplicationStatus.pending);
  }

  void refresh() {
    ref.invalidateSelf();
  }
}

@riverpod
class AcceptedApplications extends _$AcceptedApplications {
  @override
  Future<PaginatedResponse<Application>?> build() async {
    final session = ref.watch(authControllerProvider).value;
    if (session?.userType != UserType.organizer) {
      return null;
    }

    final repository = ref.watch(applicationsRepositoryProvider);
    return repository.fetchOrganizerApplications(status: ApplicationStatus.accepted);
  }

  Future<PaginatedResponse<Application>?> fetchApplications({int? page, int? limit}) async {
    final repository = ref.watch(applicationsRepositoryProvider);
    return repository.fetchOrganizerApplications(page: page, limit: limit, status: ApplicationStatus.accepted);
  }

  void refresh() {
    ref.invalidateSelf();
  }
}

@riverpod
class RejectedApplications extends _$RejectedApplications {
  @override
  Future<PaginatedResponse<Application>?> build() async {
    final session = ref.watch(authControllerProvider).value;
    if (session?.userType != UserType.organizer) {
      return null;
    }

    final repository = ref.watch(applicationsRepositoryProvider);
    return repository.fetchOrganizerApplications(status: ApplicationStatus.rejected);
  }

  Future<PaginatedResponse<Application>?> fetchApplications({int? page, int? limit}) async {
    final repository = ref.watch(applicationsRepositoryProvider);
    return repository.fetchOrganizerApplications(page: page, limit: limit, status: ApplicationStatus.rejected);
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
