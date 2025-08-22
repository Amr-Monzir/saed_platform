import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/prefs/user_prefs.dart';
import 'dart:io';
import '../../models/advert.dart';
import 'adverts_repository.dart';
import 'paginated_adverts.dart';

final searchQueryProvider = StateProvider<String?>((ref) => null);
final pageProvider = StateProvider<int>((ref) => 1);

final advertsProvider = FutureProvider<PaginatedAdverts>((ref) async {
  final repo = ref.watch(advertsRepositoryProvider);
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

final filteredAdvertsProvider = Provider<AsyncValue<PaginatedAdverts>>((ref) {
  return ref.watch(advertsProvider);
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
  final repo = ref.watch(advertsRepositoryProvider);
  return repo.fetchMine();
});

class MyAdvertsSearchController extends StateNotifier<String?> {
  MyAdvertsSearchController() : super(null);

  void setQuery(String value) {
    final trimmed = value.trim();
    state = trimmed.isEmpty ? null : trimmed;
  }

  void clear() => state = null;
}

final myAdvertsSearchControllerProvider =
    StateNotifierProvider<MyAdvertsSearchController, String?>((ref) => MyAdvertsSearchController());

final filteredMyAdvertsProvider = Provider<AsyncValue<PaginatedAdverts>>((ref) {
  final search = (ref.watch(myAdvertsSearchControllerProvider) ?? '').trim().toLowerCase();
  final mine = ref.watch(myAdvertsProvider);
  return mine.whenData((page) {
    if (search.isEmpty) return page;
    final filtered = page.items.where((a) {
      final title = a.title.toLowerCase();
      final category = a.category.toLowerCase();
      return title.contains(search) || category.contains(search);
    }).toList();
    return PaginatedAdverts(items: filtered, totalPages: page.totalPages);
  });
});

final advertsRepositoryProvider = Provider((ref) => AdvertsRepository(ref));

class CreateAdvertController extends StateNotifier<AsyncValue<Advert?>> {
  CreateAdvertController(this._ref) : super(const AsyncValue.data(null));
  
  final Ref _ref;
  
  Future<void> createAdvert(Advert advert, {File? imageFile}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _ref.read(advertsRepositoryProvider).create(advert, imageFile: imageFile);
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  void reset() {
    state = const AsyncValue.data(null);
  }
}

final createAdvertControllerProvider = StateNotifierProvider<CreateAdvertController, AsyncValue<Advert?>>((ref) {
  return CreateAdvertController(ref);
});


