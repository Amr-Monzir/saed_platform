import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/organizer.dart';
import '../../services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/auth_providers.dart';
import 'dart:convert';

abstract class OrganizerDataSource {
  Future<OrganizerResponse> me();
}

class OrganizerApiDataSource implements OrganizerDataSource {
  OrganizerApiDataSource(this._ref, this._api);
  final Ref _ref;
  final ApiService _api;

  @override
  Future<OrganizerResponse> me() async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.get('/api/v1/organizers/profile', headers: _api.authHeaders(token));
    return OrganizerResponse.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

class OrganizerMockDataSource implements OrganizerDataSource {
  OrganizerResponse _me = OrganizerResponse(id: 1, name: 'Org', logoUrl: null, website: null, description: '');
  @override
  Future<OrganizerResponse> me() async => _me;
}

class OrganizerRepository {
  OrganizerRepository(this._ref)
      : _ds = dotenv.env['ENV'] == 'local' ? OrganizerMockDataSource() : OrganizerApiDataSource(_ref, ApiService.instance);

  final Ref _ref;
  final OrganizerDataSource _ds;

  Future<OrganizerResponse> me() => _ds.me();
}

final organizerRepositoryProvider = Provider<OrganizerRepository>((ref) => OrganizerRepository(ref));


