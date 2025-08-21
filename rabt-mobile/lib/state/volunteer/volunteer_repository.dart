import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/volunteer.dart';
import '../../services/api_service.dart';
import '../auth/auth_providers.dart';

class VolunteerRepository {
  VolunteerRepository(this._ref);

  final Ref _ref;
  final ApiService _api = ApiService.instance;

  Future<VolunteerProfile> fetchVolunteerProfile() async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.get('/api/v1/volunteers/profile', headers: _api.authHeaders(token));
    return VolunteerProfile.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<VolunteerProfile> update({
    String? name,
    String? phoneNumber,
    String? city,
    String? country,
    List<int>? skillIds,
  }) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.put('/api/v1/volunteers/profile', {
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (skillIds != null) 'skill_ids': skillIds,
    }, headers: _api.authHeaders(token));
    return VolunteerProfile.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final volunteerRepositoryProvider = Provider((ref) => VolunteerRepository(ref));
