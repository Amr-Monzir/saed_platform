import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/application.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/applications/applications_repository.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/util/parse_helpers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'applications_providers.g.dart';

@riverpod
Future<PaginatedResponse<Application>?> applicationsList(
  Ref ref, {
  String? organizerId,
  String? advertId,
  int? page,
  int? limit,
}) async {
  final session = ref.watch(authControllerProvider).value;
  if (session?.userType != UserType.organizer) {
    return null;
  }
  
  final repository = ref.watch(applicationsRepositoryProvider);
  return repository.fetchOrganizerApplications(
    organizerId: organizerId,
    advertId: advertId,
    page: page,
    limit: limit,
  );
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

final updateApplicationStatusControllerProvider = StateNotifierProvider<UpdateApplicationStatusController, AsyncValue<Application?>>((ref) {
  return UpdateApplicationStatusController(ref);
});
