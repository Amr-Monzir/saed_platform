import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/application.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';

class ApplicationsRepository {
  ApplicationsRepository(this._ref);

  final Ref _ref;
  final ApiService _api = ApiService.instance;

  Future<Application> create({required int advertId, String? coverMessage}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/applications', {
      'advert_id': advertId,
      'cover_message': coverMessage,
    }, headers: _api.authHeaders(token));
    return Application.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<Application> updateStatus(int id, String status, {String? organizerMessage}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/applications/$id', {
      'status': status,
      'organizer_message': organizerMessage,
    }, headers: _api.authHeaders(token));
    return Application.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) => ApplicationsRepository(ref));

class CreateApplicationController extends StateNotifier<AsyncValue<Application?>> {
  CreateApplicationController(this._ref) : super(const AsyncValue.data(null));
  
  final Ref _ref;
  
  Future<void> createApplication({required int advertId, String? coverMessage}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _ref.read(applicationsRepositoryProvider).create(
        advertId: advertId,
        coverMessage: coverMessage,
      );
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
