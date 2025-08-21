import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'jobs_repository.dart';
import '../../models/advert.dart';
import '../prefs/user_prefs.dart';
import 'paginated_adverts.dart';
import '../../models/enums.dart';

final searchQueryProvider = StateProvider<String?>((ref) => null);
final pageProvider = StateProvider<int>((ref) => 1);

final jobsProvider = FutureProvider<PaginatedAdverts>((ref) async {
  final repo = ref.watch(advertsRepositoryProvider);
  final filters = ref.watch(jobsFilterProvider);
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

final filteredJobsProvider = Provider<AsyncValue<PaginatedAdverts>>((ref) {
  return ref.watch(jobsProvider);
});

class JobsFilterState {
  JobsFilterState({
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

  JobsFilterState copyWith({
    FrequencyType? frequency,
    String? category,
    Set<String>? skills,
    TimeCommitment? timeCommitment,
    DayTimePeriod? timeOfDay,
    int? distanceMiles,
  }) {
    return JobsFilterState(
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      skills: skills ?? this.skills,
      timeCommitment: timeCommitment ?? this.timeCommitment,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      distanceMiles: distanceMiles ?? this.distanceMiles,
    );
  }
}

class JobsFilterController extends StateNotifier<JobsFilterState> {
  JobsFilterController() : super(JobsFilterState());

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
  void clear() => state = JobsFilterState();
}

final jobsFilterProvider = StateNotifierProvider<JobsFilterController, JobsFilterState>((ref) {
  return JobsFilterController();
});

final myJobsProvider = FutureProvider<List<AdvertResponse>>((ref) async {
  final repo = ref.watch(advertsRepositoryProvider);
  return repo.fetchMine();
});


