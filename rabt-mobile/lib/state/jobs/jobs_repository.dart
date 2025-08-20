import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/advert.dart';
import '../../models/organizer.dart';
import '../../models/skill.dart';
import '../../models/enums.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/auth_providers.dart';
import 'paginated_adverts.dart';

abstract class AdvertsDataSource {
  Future<PaginatedAdverts> listAll({Map<String, String>? query});
  Future<List<AdvertResponse>> listMine(String ownerToken);
  Future<AdvertResponse?> getById(int id);
  Future<AdvertResponse> create(AdvertResponse advert);
  Future<void> close(int id);
}

class AdvertsApiDataSource implements AdvertsDataSource {
  final ApiService _api;
  final Ref _ref;
  AdvertsApiDataSource(this._ref, this._api);

  @override
  Future<AdvertResponse> create(AdvertResponse advert) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/adverts', advert.toJson(), headers: _api.authHeaders(token));
    return AdvertResponse.fromJson(_decode(resp.body));
  }

  @override
  Future<void> close(int id) async {
    final token = _ref.read(authControllerProvider).session?.token;
    await _api.post('/api/v1/adverts/$id/close', {}, headers: _api.authHeaders(token));
  }

  @override
  Future<AdvertResponse?> getById(int id) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.get('/api/v1/adverts/$id', headers: _api.authHeaders(token));
    return AdvertResponse.fromJson(_decode(resp.body));
  }

  @override
  Future<PaginatedAdverts> listAll({Map<String, String>? query}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final uri = Uri.parse('${_api.baseUrl}/api/v1/adverts').replace(queryParameters: query);
    final resp = await http.get(uri, headers: _api.authHeaders(token));
    final json = _decode(resp.body) as Map<String, dynamic>;
    final data = (json['items'] as List<dynamic>).map((e) => AdvertResponse.fromJson(e as Map<String, dynamic>)).toList();
    final totalPages = (json['total_pages'] as num?)?.toInt() ?? 1;
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  @override
  Future<List<AdvertResponse>> listMine(String ownerToken) async {
    final resp = await _api.get('/api/v1/adverts?owner=me', headers: _api.authHeaders(ownerToken));
    final data = _decode(resp.body) as List<dynamic>;
    return data.map((e) => AdvertResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  dynamic _decode(String body) {
    return ApiService.instance.decodeJson(body);
  }
}

class AdvertsMockDataSource implements AdvertsDataSource {
  final List<AdvertResponse> _items;
  AdvertsMockDataSource(this._items);

  @override
  Future<AdvertResponse> create(AdvertResponse advert) async {
    _items.add(advert);
    return advert;
  }

  @override
  Future<void> close(int id) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _items[idx];
      _items[idx] = AdvertResponse(
        id: current.id,
        title: current.title,
        description: current.description,
        category: current.category,
        frequency: current.frequency,
        numberOfVolunteers: current.numberOfVolunteers,
        locationType: current.locationType,
        addressText: current.addressText,
        postcode: current.postcode,
        latitude: current.latitude,
        longitude: current.longitude,
        advertImageUrl: current.advertImageUrl,
        isActive: false,
        organizer: current.organizer,
        requiredSkills: current.requiredSkills,
        oneoffDetails: current.oneoffDetails,
        recurringDetails: current.recurringDetails,
        createdAt: current.createdAt,
      );
    }
  }

  @override
  Future<AdvertResponse?> getById(int id) async {
    return _items.firstWhere((e) => e.id == id, orElse: () => _items.first);
  }

  @override
  Future<PaginatedAdverts> listAll({Map<String, String>? query}) async {
    // Basic mock filtering by category/frequency and search 'q'
    Iterable<AdvertResponse> res = _items;
    final q = query ?? {};
    if (q['category'] != null) res = res.where((e) => e.category == q['category']);
    if (q['frequency'] != null) res = res.where((e) => e.frequency.name == q['frequency']);
    if (q['q'] != null && q['q']!.isNotEmpty) {
      final term = q['q']!.toLowerCase();
      res = res.where((e) => e.title.toLowerCase().contains(term) || e.description.toLowerCase().contains(term));
    }
    // Skills filtering (expects comma-separated names)
    if (q['skills'] != null && q['skills']!.isNotEmpty) {
      final want = q['skills']!.split(',').map((e) => e.trim()).toSet();
      res = res.where((e) => e.requiredSkills.any((s) => want.contains(s.name)));
    }
    // Time commitment and time of day on nested details
    if (q['time_commitment'] != null) {
      final tc = q['time_commitment'];
      res = res.where((e) =>
          (e.oneoffDetails?.timeCommitment.name == tc) || (e.recurringDetails?.timeCommitmentPerSession.name == tc));
    }
    if (q['time_of_day'] != null) {
      final tod = q['time_of_day'];
      res = res.where((e) => e.recurringDetails?.specificDays.any((d) => d.periods.any((p) => p.name == tod)) ?? false);
    }
    // City/distance approximation: include all for mock; real filter is backend
    final page = int.tryParse(q['page'] ?? '1') ?? 1;
    const pageSize = 10;
    final start = (page - 1) * pageSize;
    final list = res.toList();
    final totalPages = (list.length / pageSize).ceil().clamp(1, 9999);
    final items = list.skip(start).take(pageSize).toList();
    return PaginatedAdverts(items: items, totalPages: totalPages);
  }

  @override
  Future<List<AdvertResponse>> listMine(String ownerToken) async {
    return List.unmodifiable(_items);
  }
}

class AdvertsRepository {
  AdvertsRepository(this._ref)
      : _ds = dotenv.env['ENV'] == 'local'
            ? AdvertsMockDataSource(_seed())
            : AdvertsApiDataSource(_ref, ApiService.instance);

  final Ref _ref;
  final AdvertsDataSource _ds;

  Future<PaginatedAdverts> fetchAll({Map<String, String>? query}) => _ds.listAll(query: query);
  Future<List<AdvertResponse>> fetchMine() async {
    final token = _ref.read(authControllerProvider).session?.token ?? '';
    return _ds.listMine(token);
  }
  Future<AdvertResponse?> getById(int id) => _ds.getById(id);
  Future<AdvertResponse> create(AdvertResponse advert) => _ds.create(advert);
  Future<void> close(int id) => _ds.close(id);

  static List<AdvertResponse> _seed() {
    // Lightweight seed matching schema
    final org = OrganizerResponse(id: 1, name: 'Climate Org', logoUrl: null, website: null, description: 'Save the planet');
    final skills = [
      SkillResponse(id: 1, name: 'Social Media', category: 'Media', isPredefined: true),
      SkillResponse(id: 2, name: 'Writing', category: 'Media', isPredefined: true),
    ];
    return [
      AdvertResponse(
        id: 1,
        title: 'Community Outreach Helper',
        description: 'Help us reach out to the community.',
        category: 'Community Outreach',
        frequency: FrequencyType.oneOff,
        numberOfVolunteers: 5,
        locationType: LocationType.onSite,
        isActive: true,
        organizer: org,
        requiredSkills: skills,
        oneoffDetails: OneOffAdvertDetails(
          eventDatetime: DateTime.now().add(const Duration(days: 7)),
          timeCommitment: TimeCommitment.oneToTwo,
          applicationDeadline: DateTime.now().add(const Duration(days: 5)),
        ),
        recurringDetails: null,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AdvertResponse(
        id: 2,
        title: 'Social Media Volunteer',
        description: 'Create posts and engage audience.',
        category: 'Digital Campaign',
        frequency: FrequencyType.recurring,
        numberOfVolunteers: 2,
        locationType: LocationType.remote,
        isActive: true,
        organizer: org,
        requiredSkills: skills,
        oneoffDetails: null,
        recurringDetails: RecurringAdvertDetails(
          recurrence: RecurrenceType.weekly,
          timeCommitmentPerSession: TimeCommitment.threeToFive,
          duration: DurationType.threeMonths,
          specificDays: [RecurringDays(day: 'Monday', periods: [DayPeriod.pm])],
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}

final advertsRepositoryProvider = Provider<AdvertsRepository>((ref) => AdvertsRepository(ref));


