import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/application.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'applications_repository.g.dart';

@riverpod
class ApplicationsRepository extends _$ApplicationsRepository {
  @override
  Future<List<Application>?> build() async {
    if (ref.read(authControllerProvider).value?.userType != UserType.organizer) {
      return null;
    }
    final token = ref.read(authControllerProvider).value?.token;

    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/applications/organization/', headers: ref.read(apiServiceProvider).authHeaders(token));
    return (jsonDecode(resp.body) as List).map((e) => Application.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Application> create({required int advertId, String? coverMessage}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final resp = await ref.read(apiServiceProvider).post('/api/v1/applications', {
      'advert_id': advertId,
      'cover_message': coverMessage,
    }, headers: ref.read(apiServiceProvider).authHeaders(token));
    return Application.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<Application> updateStatus(int id, String status, {String? organizerMessage}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final resp = await ref.read(apiServiceProvider).post('/api/v1/applications/$id', {
      'status': status,
      'organizer_message': organizerMessage,
    }, headers: ref.read(apiServiceProvider).authHeaders(token));
    return Application.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<List<Application>> fetchApplications(String organizerId, {String? advertId, int? page, int? limit}) async {
    if (ref.read(authControllerProvider).value?.userType != UserType.organizer) {
      throw Exception('Only organizations can fetch applications');
    }
    final token = ref.read(authControllerProvider).value?.token;
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    if (advertId != null) query['advert_id'] = advertId;
    final resp = await ref
        .read(apiServiceProvider)
        .get(
          '/api/v1/applications/organization/$organizerId',
          query: query,
          headers: ref.read(apiServiceProvider).authHeaders(token),
        );
    return (jsonDecode(resp.body) as List).map((e) => Application.fromJson(e as Map<String, dynamic>)).toList();
  }
}

class CreateApplicationController extends StateNotifier<AsyncValue<Application?>> {
  CreateApplicationController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> createApplication({required int advertId, String? coverMessage}) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref
          .read(applicationsRepositoryProvider.notifier)
          .create(advertId: advertId, coverMessage: coverMessage);
      state = AsyncValue.data(result);
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
