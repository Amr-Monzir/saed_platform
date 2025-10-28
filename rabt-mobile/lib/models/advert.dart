// coverage:ignore-file
import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'skill.dart';
import 'organizer.dart';

part 'advert.freezed.dart';
part 'advert.g.dart';

@freezed
class RecurringDays with _$RecurringDays {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RecurringDays({
    required String day, // backend uses string day key
    required List<DayTimePeriod> periods,
  }) = _RecurringDays;

  factory RecurringDays.fromJson(Map<String, dynamic> json) => _$RecurringDaysFromJson(json);
}

@freezed
class RecurringAdvertDetails with _$RecurringAdvertDetails {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RecurringAdvertDetails({
    required RecurrenceType recurrence,
    required TimeCommitment timeCommitmentPerSession,
    required DurationType duration,
    required List<RecurringDays> specificDays,
  }) = _RecurringAdvertDetails;

  factory RecurringAdvertDetails.fromJson(Map<String, dynamic> json) => _$RecurringAdvertDetailsFromJson(json);
}

@freezed
class OneOffAdvertDetails with _$OneOffAdvertDetails {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OneOffAdvertDetails({
    required DateTime eventDatetime,
    required TimeCommitment timeCommitment,
    required DateTime applicationDeadline,
  }) = _OneOffAdvertDetails;

  factory OneOffAdvertDetails.fromJson(Map<String, dynamic> json) => _$OneOffAdvertDetailsFromJson(json);
}

@freezed
class Advert with _$Advert {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Advert({
    required int id,
    required String title,
    required String description,
    required String category,
    required FrequencyType frequency,
    required int numberOfVolunteers,
    required LocationType locationType,
    String? addressText,
    String? postcode,
    String? imageUrl,
    String? city,
    required bool isActive,
    required OrganizerProfile organizer,
    @Default([]) List<Skill> requiredSkills,
    OneOffAdvertDetails? oneoffDetails,
    RecurringAdvertDetails? recurringDetails,
    required DateTime createdAt,
  }) = _Advert;

  factory Advert.fromJson(Map<String, dynamic> json) => _$AdvertFromJson(json);
}


