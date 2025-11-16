import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/application.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/util/parse_helpers.dart';

class ApplicationsRepository {
  ApplicationsRepository(this.ref);
  final Ref ref;

  Future<PaginatedResponse<Application>> fetchOrganizerApplications({int? advertId, int? page, int? limit, ApplicationStatus? status}) async {
    if (ref.read(authControllerProvider).value?.userType != UserType.organizer) {
      throw Exception('Only organizations can fetch applications');
    }
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    if (advertId != null) query['advert_id'] = advertId.toString();
    if (status != null) query['status'] = status.name;
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/applications/organization', query: query);
    return parsePaginated(resp, (e) => Application.fromJson(e));
  }

  Future<Application> create({required int advertId, String? coverMessage}) async {
    final resp = await ref.read(apiServiceProvider).post('/api/v1/applications', {
      'advert_id': advertId,
      'cover_message': coverMessage,
    });
    return parseObject(resp, (e) => Application.fromJson(e));
  }

  Future<Application> updateStatus(int id, ApplicationStatus status, {String? organizerMessage}) async {
    final resp = await ref.read(apiServiceProvider).put('/api/v1/applications/$id/status', {
      'status': status.name,
      'organizer_message': organizerMessage,
    });
    return parseObject(resp, (e) => Application.fromJson(e));
  }
}

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) => ApplicationsRepository(ref));
