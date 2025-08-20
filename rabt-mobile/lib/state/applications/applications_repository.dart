import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/application.dart';
import '../../models/advert.dart';
import '../../models/organizer.dart';
import '../../models/enums.dart' as e;
import '../../services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/auth_providers.dart';

abstract class ApplicationsDataSource {
  Future<ApplicationResponse> create({required int advertId, String? coverMessage});
  Future<ApplicationResponse> updateStatus(int id, String status, {String? organizerMessage});
}

class ApplicationsApiDataSource implements ApplicationsDataSource {
  final ApiService _api;
  final Ref _ref;
  ApplicationsApiDataSource(this._ref, this._api);

  @override
  Future<ApplicationResponse> create({required int advertId, String? coverMessage}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/applications', {
      'advert_id': advertId,
      'cover_message': coverMessage,
    }, headers: _api.authHeaders(token));
    return ApplicationResponse.fromJson(ApiService.instance.decodeJson(resp.body) as Map<String, dynamic>);
  }

  @override
  Future<ApplicationResponse> updateStatus(int id, String status, {String? organizerMessage}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/applications/$id', {
      'status': status,
      'organizer_message': organizerMessage,
    }, headers: _api.authHeaders(token));
    return ApplicationResponse.fromJson(ApiService.instance.decodeJson(resp.body) as Map<String, dynamic>);
  }
}

class ApplicationsMockDataSource implements ApplicationsDataSource {
  int _seq = 1;
  @override
  Future<ApplicationResponse> create({required int advertId, String? coverMessage}) async {
    return ApplicationResponse(
      id: _seq++,
      advertId: advertId,
      coverMessage: coverMessage,
      status: e.ApplicationStatus.pending,
      appliedAt: DateTime.now(),
      advert: AdvertResponse(
        id: advertId,
        title: 'Mock',
        description: 'Mock',
        category: 'Mock',
        frequency: e.FrequencyType.oneOff,
        numberOfVolunteers: 1,
        locationType: e.LocationType.remote,
        isActive: true,
        organizer: OrganizerResponse(id: 1, name: 'Mock'),
        requiredSkills: const [],
        oneoffDetails: OneOffAdvertDetails(
          eventDatetime: DateTime.now(),
          timeCommitment: e.TimeCommitment.oneToTwo,
          applicationDeadline: DateTime.now().add(const Duration(days: 7)),
        ),
        createdAt: DateTime.now(),
      ),
      volunteer: null,
    );
  }

  @override
  Future<ApplicationResponse> updateStatus(int id, String status, {String? organizerMessage}) async {
    return ApplicationResponse(
      id: id,
      advertId: 1,
      coverMessage: organizerMessage,
      status: e.ApplicationStatus.accepted,
      appliedAt: DateTime.now(),
      advert: AdvertResponse(
        id: 1,
        title: 'Mock',
        description: 'Mock',
        category: 'Mock',
        frequency: e.FrequencyType.oneOff,
        numberOfVolunteers: 1,
        locationType: e.LocationType.remote,
        isActive: true,
        organizer: OrganizerResponse(id: 1, name: 'Mock'),
        requiredSkills: const [],
        oneoffDetails: OneOffAdvertDetails(
          eventDatetime: DateTime.now(),
          timeCommitment: e.TimeCommitment.oneToTwo,
          applicationDeadline: DateTime.now().add(const Duration(days: 7)),
        ),
        createdAt: DateTime.now(),
      ),
      volunteer: null,
    );
  }
}

class ApplicationsRepository {
  ApplicationsRepository(this._ref)
      : _ds = dotenv.env['ENV'] == 'local'
            ? ApplicationsMockDataSource()
            : ApplicationsApiDataSource(_ref, ApiService.instance);

  final Ref _ref;
  final ApplicationsDataSource _ds;

  Future<ApplicationResponse> create({required int advertId, String? coverMessage}) =>
      _ds.create(advertId: advertId, coverMessage: coverMessage);
  Future<ApplicationResponse> updateStatus(int id, String status, {String? organizerMessage}) =>
      _ds.updateStatus(id, status, organizerMessage: organizerMessage);
}

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) => ApplicationsRepository(ref));


