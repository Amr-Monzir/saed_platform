import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/volunteer.dart';
import '../../services/api_service.dart';
import '../auth/auth_providers.dart';

class VolunteerRepository {
  VolunteerRepository(this.ref);

  final Ref ref;

  Future<VolunteerProfile> fetchVolunteerProfile() async {
    final token = ref.read(authControllerProvider).session?.token;
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/volunteers/profile', headers: ref.read(apiServiceProvider).authHeaders(token));
    return VolunteerProfile.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<VolunteerProfile> update({String? name, String? phoneNumber, String? city, String? country, List<int>? skillIds}) async {
    final token = ref.read(authControllerProvider).session?.token;
    final resp = await ref.read(apiServiceProvider).put('/api/v1/volunteers/profile', {
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (skillIds != null) 'skill_ids': skillIds,
    }, headers: ref.read(apiServiceProvider).authHeaders(token));
    return VolunteerProfile.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final volunteerRepositoryProvider = Provider((ref) => VolunteerRepository(ref));
