import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/volunteer.dart';
import '../../services/api_service.dart';
import '../auth/auth_providers.dart';

class VolunteerRepository {
  VolunteerRepository(this.ref);

  final Ref ref;

  Future<VolunteerProfile> fetchVolunteerProfile(String token) async {
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/volunteers/profile', headers: ref.read(apiServiceProvider).authHeaders(token));
    return VolunteerProfile.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<VolunteerProfile> update({String? name, String? phoneNumber, List<int>? skillIds}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final resp = await ref.read(apiServiceProvider).put('/api/v1/volunteers/profile', {
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (skillIds != null) 'skill_ids': skillIds,
    }, headers: ref.read(apiServiceProvider).authHeaders(token));
    return VolunteerProfile.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final volunteerRepositoryProvider = Provider((ref) => VolunteerRepository(ref));

// Provider for volunteer profile
final volunteerProfileProvider = FutureProvider<VolunteerProfile?>((ref) async {
  final session = ref.watch(authControllerProvider).value;
  if (session == null) return null;
  
  final repository = ref.watch(volunteerRepositoryProvider);
  return repository.fetchVolunteerProfile(session.token);
});
