import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/state/adverts/adverts_repository.dart';
import 'package:rabt_mobile/state/prefs/user_prefs.dart';
import 'package:rabt_mobile/state/adverts/paginated_adverts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'adverts_providers.g.dart';

// State providers for filtering and pagination
final searchQueryProvider = StateProvider<String?>((ref) => null);
final pageProvider = StateProvider<int>((ref) => 1);

// Main adverts provider that handles filtering and pagination
final advertsProvider = FutureProvider<PaginatedAdverts>((ref) async {
  final repo = ref.watch(advertsRepositoryProvider);
  final filters = ref.watch(advertsFilterProvider);
  final search = ref.watch(searchQueryProvider);
  final page = ref.watch(pageProvider);
  final Map<String, String> query = {};
  if (filters.frequency != null) query['frequency'] = filters.frequency!.wireValue;
  if (filters.category != null) query['category'] = filters.category!;
  if (filters.skills.isNotEmpty) query['skills'] = filters.skills.join(',');
  if (filters.timeCommitment != null) query['time_commitment'] = filters.timeCommitment!.wireValue;
  if (filters.timeOfDay != null) query['time_of_day'] = filters.timeOfDay!.wireValue;
  if (filters.locationType != null) query['location_type'] = filters.locationType!.wireValue;
  if (filters.city != null && filters.city!.isNotEmpty) query['city'] = filters.city!;
  if (search != null && search.isNotEmpty) query['q'] = search;
  if (page > 1) query['page'] = page.toString();
  return repo.fetchAll(query: query.isEmpty ? null : query);
});

@riverpod
Future<Advert?> advertById(Ref ref, int id) async {
  final repo = ref.read(advertsRepositoryProvider);
  return repo.getById(id);
}

final myAdvertsProvider = FutureProvider<List<Advert>>((ref) async {
  final repo = ref.watch(advertsRepositoryProvider);
  return repo.fetchMine();
});

class AdvertsFilterState {
  AdvertsFilterState({
    this.frequency,
    this.category,
    this.recurrence,
    this.skills = const <String>{},
    this.timeCommitment,
    this.timeOfDay,
    this.distanceMiles,
    this.locationType,
    this.city,
  });

  final FrequencyType? frequency;
  final String? category;
  final RecurrenceType? recurrence;
  final Set<String> skills;
  final TimeCommitment? timeCommitment;
  final DayTimePeriod? timeOfDay;
  final int? distanceMiles;
  final LocationType? locationType;
  final String? city;

  // Sentinel value to distinguish between "not provided" and "explicitly null"
  static const Object _notProvided = Object();

  AdvertsFilterState copyWith({
    Object? frequency = _notProvided,
    Object? category = _notProvided,
    Object? recurrence = _notProvided,
    Object? skills = _notProvided,
    Object? timeCommitment = _notProvided,
    Object? timeOfDay = _notProvided,
    Object? distanceMiles = _notProvided,
    Object? locationType = _notProvided,
    Object? city = _notProvided,
  }) {
    return AdvertsFilterState(
      frequency: frequency == _notProvided ? this.frequency : frequency as FrequencyType?,
      category: category == _notProvided ? this.category : category as String?,
      recurrence: recurrence == _notProvided ? this.recurrence : recurrence as RecurrenceType?,
      skills: skills == _notProvided ? this.skills : skills as Set<String>,
      timeCommitment: timeCommitment == _notProvided ? this.timeCommitment : timeCommitment as TimeCommitment?,
      timeOfDay: timeOfDay == _notProvided ? this.timeOfDay : timeOfDay as DayTimePeriod?,
      distanceMiles: distanceMiles == _notProvided ? this.distanceMiles : distanceMiles as int?,
      locationType: locationType == _notProvided ? this.locationType : locationType as LocationType?,
      city: city == _notProvided ? this.city : city as String?,
    );
  }
}

class AdvertsFilterController extends StateNotifier<AdvertsFilterState> {
  AdvertsFilterController() : super(AdvertsFilterState());

  void setFrequency(FrequencyType? value) => state = state.copyWith(frequency: value);

  void setRecurrence(RecurrenceType? value) => state = state.copyWith(recurrence: value);

  void setCategory(String? value) => state = state.copyWith(category: value);

  void setLocationType(LocationType? value) => state = state.copyWith(locationType: value);

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
  void setCity(String? value) => state = state.copyWith(city: value);
  void clear() => state = AdvertsFilterState();

  // Clear all filters
  void clearAll() => state = AdvertsFilterState();
}

final advertsFilterProvider = StateNotifierProvider<AdvertsFilterController, AdvertsFilterState>((ref) {
  return AdvertsFilterController();
});

class CreateAdvertController extends StateNotifier<AsyncValue<Advert?>> {
  CreateAdvertController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> createAdvert(Advert advert, {File? imageFile}) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(advertsRepositoryProvider);
      final result = await repository.create(advert, imageFile: imageFile);
      state = AsyncValue.data(result);

      // Invalidate the adverts list to refresh it
      ref.invalidate(advertsProvider);
      ref.invalidate(myAdvertsProvider);
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

class CloseAdvertController extends StateNotifier<AsyncValue<void>> {
  CloseAdvertController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> closeAdvert(int id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(advertsRepositoryProvider);
      await repository.close(id);
      state = const AsyncValue.data(null);

      // Invalidate the adverts list to refresh it
      ref.invalidate(advertsProvider);
      ref.invalidate(myAdvertsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final closeAdvertControllerProvider = StateNotifierProvider<CloseAdvertController, AsyncValue<void>>((ref) {
  return CloseAdvertController(ref);
});

// My Adverts Search Controller
class MyAdvertsSearchController extends StateNotifier<String?> {
  MyAdvertsSearchController() : super(null);

  void setQuery(String value) {
    final trimmed = value.trim();
    state = trimmed.isEmpty ? null : trimmed;
  }

  void clear() => state = null;
}

final myAdvertsSearchControllerProvider = StateNotifierProvider<MyAdvertsSearchController, String?>(
  (ref) => MyAdvertsSearchController(),
);

final filteredMyAdvertsProvider = Provider<AsyncValue<List<Advert>>>((ref) {
  final search = (ref.watch(myAdvertsSearchControllerProvider) ?? '').trim().toLowerCase();
  final mine = ref.watch(myAdvertsProvider);
  return mine.whenData((data) {
    if (search.isEmpty) return data;
    final filtered =
        data.where((a) {
          final title = a.title.toLowerCase();
          final category = a.category.toLowerCase();
          return title.contains(search) || category.contains(search);
        }).toList();
    return filtered;
  });
});
