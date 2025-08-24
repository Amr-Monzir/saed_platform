import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/services/image_upload_service.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/state/prefs/user_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'paginated_adverts.dart';

part 'adverts_repository.g.dart';

// State providers for filtering and pagination
final searchQueryProvider = StateProvider<String?>((ref) => null);
final pageProvider = StateProvider<int>((ref) => 1);

// Main adverts provider that handles filtering and pagination
final advertsProvider = FutureProvider<PaginatedAdverts>((ref) async {
  final repo = ref.watch(advertsRepositoryProvider.notifier);
  final filters = ref.watch(advertsFilterProvider);
  final prefs = ref.watch(userPrefsProvider);
  final search = ref.watch(searchQueryProvider);
  final page = ref.watch(pageProvider);
  final Map<String, String> query = {};
  if (filters.frequency != null) query['frequency'] = filters.frequency!.wireValue;
  if (filters.category != null) query['category'] = filters.category!;
  if (filters.skills.isNotEmpty) query['skills'] = filters.skills.join(',');
  if (filters.timeCommitment != null) query['time_commitment'] = filters.timeCommitment!.wireValue;
  if (filters.timeOfDay != null) query['time_of_day'] = filters.timeOfDay!.wireValue;
  if (prefs.distanceMiles != null) query['distance'] = prefs.distanceMiles!.toString();
  if (prefs.city != null && prefs.city!.isNotEmpty) query['city'] = prefs.city!;
  if (search != null && search.isNotEmpty) query['q'] = search;
  if (page > 1) query['page'] = page.toString();
  return repo.fetchAll(query: query.isEmpty ? null : query);
});

class AdvertsFilterState {
  AdvertsFilterState({
    this.frequency,
    this.category,
    this.skills = const <String>{},
    this.timeCommitment,
    this.timeOfDay,
    this.distanceMiles,
  });

  final FrequencyType? frequency;
  final String? category;
  final Set<String> skills;
  final TimeCommitment? timeCommitment;
  final DayTimePeriod? timeOfDay;
  final int? distanceMiles;

  AdvertsFilterState copyWith({
    FrequencyType? frequency,
    String? category,
    Set<String>? skills,
    TimeCommitment? timeCommitment,
    DayTimePeriod? timeOfDay,
    int? distanceMiles,
  }) {
    return AdvertsFilterState(
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      skills: skills ?? this.skills,
      timeCommitment: timeCommitment ?? this.timeCommitment,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      distanceMiles: distanceMiles ?? this.distanceMiles,
    );
  }
}

class AdvertsFilterController extends StateNotifier<AdvertsFilterState> {
  AdvertsFilterController() : super(AdvertsFilterState());

  void setFrequency(FrequencyType? value) => state = state.copyWith(frequency: value);
  void setCategory(String? value) => state = state.copyWith(category: value);
  void toggleSkill(String skill) {
    final newSet = {...state.skills};
    if (newSet.contains(skill)) {
      newSet.remove(skill);
    } else {
      newSet.add(skill);
    }
    state = state.copyWith(skills: newSet);
  }
  void setTimeCommitment(TimeCommitment? value) => state = state.copyWith(timeCommitment: value);
  void setTimeOfDay(DayTimePeriod? value) => state = state.copyWith(timeOfDay: value);
  void setDistance(int? miles) => state = state.copyWith(distanceMiles: miles);
  void clear() => state = AdvertsFilterState();
}

final advertsFilterProvider = StateNotifierProvider<AdvertsFilterController, AdvertsFilterState>((ref) {
  return AdvertsFilterController();
});

final myAdvertsProvider = FutureProvider<PaginatedAdverts>((ref) async {
  final repo = ref.watch(advertsRepositoryProvider.notifier);
  return repo.fetchMine();
});

@riverpod
class AdvertsRepository extends _$AdvertsRepository {

  @override
  Future<PaginatedAdverts> build() async {
    return fetchAll();
  }

  Future<PaginatedAdverts> fetchAll({Map<String, String>? query}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final uri = Uri.parse('${ref.read(apiServiceProvider).baseUrl}/api/v1/adverts').replace(queryParameters: query);
    final resp = await http.get(uri, headers: ref.read(apiServiceProvider).authHeaders(token));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    List<Advert> data;
    int totalPages;
    data = (json['items'] as List<dynamic>).map((e) => Advert.fromJson(e as Map<String, dynamic>)).toList();
    totalPages = (json['total_pages'] as num).toInt();
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  Future<PaginatedAdverts> fetchMine() async {
    final token = ref.read(authControllerProvider).value?.token ?? '';
    final resp = await ref.read(apiServiceProvider).get('/api/v1/adverts?owner=me', headers: ref.read(apiServiceProvider).authHeaders(token));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    List<Advert> data;
    int totalPages;
    data = (json['items'] as List<dynamic>).map((e) => Advert.fromJson(e as Map<String, dynamic>)).toList();
    totalPages = (json['total_pages'] as num).toInt();
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  Future<Advert?> getById(int id) async {
    final token = ref.read(authControllerProvider).value?.token;
    final resp = await ref.read(apiServiceProvider).get('/api/v1/adverts/$id', headers: ref.read(apiServiceProvider).authHeaders(token));
    return Advert.fromJson(jsonDecode(resp.body));
  }

  Future<Advert?> create(Advert advert, {File? imageFile}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final advertData = advert.toJson();

    if (imageFile != null) {
      final imageUrl = await ref.read(imageUploadServiceProvider).uploadImageWithCategory(imageFile, category: 'adverts', token: token);
      if (imageUrl != null) advertData['advert_image_url'] = imageUrl;
    }

    final resp = await ref.read(apiServiceProvider).post('/api/v1/adverts', advertData, headers: ref.read(apiServiceProvider).authHeaders(token));
    return Advert.fromJson(jsonDecode(resp.body));
  }

  Future<void> close(int id) async {
    final token = ref.read(authControllerProvider).value?.token;
    await ref.read(apiServiceProvider).post('/api/v1/adverts/$id/close', {}, headers: ref.read(apiServiceProvider).authHeaders(token));
  }
}
