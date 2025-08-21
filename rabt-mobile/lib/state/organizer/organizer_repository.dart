import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/organizer.dart';
import '../../services/api_service.dart';
import '../auth/auth_providers.dart';
import 'dart:convert';

class OrganizerRepository {
  OrganizerRepository(this._ref);

  final Ref _ref;
  final ApiService _api = ApiService.instance;

  Future<OrganizerProfile> fetchOrganizerProfile() async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.get('/api/v1/organizers/profile', headers: _api.authHeaders(token));
    return OrganizerProfile.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final organizerRepositoryProvider = Provider((ref) => OrganizerRepository(ref));
