import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/application.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/util/parse_helpers.dart';

class ApplicationsRepository {
  ApplicationsRepository(this.ref);
  final Ref ref;

  Future<PaginatedResponse<Application>> fetchOrganizerApplications({int? advertId, int? page, int? limit}) async {
    if (ref.read(authControllerProvider).value?.userType != UserType.organizer) {
      throw Exception('Only organizations can fetch applications');
    }
    final token = ref.read(authControllerProvider).value?.token;
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    if (advertId != null) query['advert_id'] = advertId.toString();
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/applications/organization', query: query, headers: ref.read(apiServiceProvider).authHeaders(token));
    return parsePaginated(resp, (e) => Application.fromJson(e));
  }

  Future<Application> create({required int advertId, String? coverMessage}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final resp = await ref.read(apiServiceProvider).post('/api/v1/applications', {
      'advert_id': advertId,
      'cover_message': coverMessage,
    }, headers: ref.read(apiServiceProvider).authHeaders(token));
    return parseObject(resp, (e) => Application.fromJson(e));
  }

  Future<Application> updateStatus(int id, ApplicationStatus status, {String? organizerMessage}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final resp = await ref.read(apiServiceProvider).post('/api/v1/applications/$id', {
      'status': status.name,
      'organizer_message': organizerMessage,
    }, headers: ref.read(apiServiceProvider).authHeaders(token));
    return parseObject(resp, (e) => Application.fromJson(e));
  }
}

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) => ApplicationsRepository(ref));
