import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/application.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';

class ApplicationsRepository {
  ApplicationsRepository(this._ref);

  final Ref _ref;
  final ApiService _api = ApiService.instance;

  Future<ApplicationResponse> create({required int advertId, String? coverMessage}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/applications', {
      'advert_id': advertId,
      'cover_message': coverMessage,
    }, headers: _api.authHeaders(token));
    return ApplicationResponse.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<ApplicationResponse> updateStatus(int id, String status, {String? organizerMessage}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/applications/$id', {
      'status': status,
      'organizer_message': organizerMessage,
    }, headers: _api.authHeaders(token));
    return ApplicationResponse.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final applicationsRepositoryProvider = Provider((ref) => ApplicationsRepository(ref));
