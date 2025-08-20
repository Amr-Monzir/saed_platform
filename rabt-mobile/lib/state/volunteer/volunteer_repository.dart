import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/volunteer.dart';
import '../../services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/auth_providers.dart';

abstract class VolunteerDataSource {
  Future<VolunteerResponse> me();
  Future<VolunteerResponse> update({String? name, String? phoneNumber, String? city, String? country, List<int>? skillIds});
}

class VolunteerApiDataSource implements VolunteerDataSource {
  final ApiService _api;
  final Ref _ref;
  VolunteerApiDataSource(this._ref, this._api);
  @override
  Future<VolunteerResponse> me() async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.get('/api/v1/volunteers/profile', headers: _api.authHeaders(token));
    return VolunteerResponse.fromJson(ApiService.instance.decodeJson(resp.body) as Map<String, dynamic>);
  }

  @override
  Future<VolunteerResponse> update({String? name, String? phoneNumber, String? city, String? country, List<int>? skillIds}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.put('/api/v1/volunteers/profile', {
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (skillIds != null) 'skill_ids': skillIds,
    }, headers: _api.authHeaders(token));
    return VolunteerResponse.fromJson(ApiService.instance.decodeJson(resp.body) as Map<String, dynamic>);
  }
}

class VolunteerMockDataSource implements VolunteerDataSource {
  VolunteerResponse _me = VolunteerResponse(id: 1, name: 'Volunteer', onboardingCompleted: false, skills: const []);
  @override
  Future<VolunteerResponse> me() async => _me;

  @override
  Future<VolunteerResponse> update({String? name, String? phoneNumber, String? city, String? country, List<int>? skillIds}) async {
    _me = VolunteerResponse(
      id: _me.id,
      name: name ?? _me.name,
      phoneNumber: phoneNumber ?? _me.phoneNumber,
      city: city ?? _me.city,
      country: country ?? _me.country,
      onboardingCompleted: true,
      skills: _me.skills,
    );
    return _me;
  }
}

class VolunteerRepository {
  VolunteerRepository(this._ref)
      : _ds = dotenv.env['ENV'] == 'local' ? VolunteerMockDataSource() : VolunteerApiDataSource(_ref, ApiService.instance);

  final Ref _ref;
  final VolunteerDataSource _ds;

  Future<VolunteerResponse> me() => _ds.me();
  Future<VolunteerResponse> update({String? name, String? phoneNumber, String? city, String? country, List<int>? skillIds}) =>
      _ds.update(name: name, phoneNumber: phoneNumber, city: city, country: country, skillIds: skillIds);
}

final volunteerRepositoryProvider = Provider<VolunteerRepository>((ref) => VolunteerRepository(ref));


