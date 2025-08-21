import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';
import 'skill.dart';
import 'organizer.dart';

part 'advert.g.dart';

@JsonSerializable()
class RecurringDays {
  RecurringDays({required this.day, required this.periods});
  final String day; // backend uses string day key
  final List<DayTimePeriod> periods;

  factory RecurringDays.fromJson(Map<String, dynamic> json) => _$RecurringDaysFromJson(json);
  Map<String, dynamic> toJson() => _$RecurringDaysToJson(this);
}

@JsonSerializable()
class RecurringAdvertDetails {
  RecurringAdvertDetails({
    required this.recurrence,
    required this.timeCommitmentPerSession,
    required this.duration,
    required this.specificDays,
  });
  final RecurrenceType recurrence;
  @JsonKey(name: 'time_commitment_per_session')
  final TimeCommitment timeCommitmentPerSession;
  final DurationType duration;
  @JsonKey(name: 'specific_days')
  final List<RecurringDays> specificDays;

  factory RecurringAdvertDetails.fromJson(Map<String, dynamic> json) => _$RecurringAdvertDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$RecurringAdvertDetailsToJson(this);
}

@JsonSerializable()
class OneOffAdvertDetails {
  OneOffAdvertDetails({required this.eventDatetime, required this.timeCommitment, required this.applicationDeadline});
  @JsonKey(name: 'event_datetime')
  final DateTime eventDatetime;
  @JsonKey(name: 'time_commitment')
  final TimeCommitment timeCommitment;
  @JsonKey(name: 'application_deadline')
  final DateTime applicationDeadline;

  factory OneOffAdvertDetails.fromJson(Map<String, dynamic> json) => _$OneOffAdvertDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$OneOffAdvertDetailsToJson(this);
}

@JsonSerializable()
class AdvertResponse {
  AdvertResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.numberOfVolunteers,
    required this.locationType,
    this.addressText,
    this.postcode,
    this.latitude,
    this.longitude,
    this.advertImageUrl,
    required this.isActive,
    required this.organizer,
    this.requiredSkills = const [],
    this.oneoffDetails,
    this.recurringDetails,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final FrequencyType frequency;
  @JsonKey(name: 'number_of_volunteers')
  final int numberOfVolunteers;
  @JsonKey(name: 'location_type')
  final LocationType locationType;
  @JsonKey(name: 'address_text')
  final String? addressText;
  final String? postcode;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'advert_image_url')
  final String? advertImageUrl;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final OrganizerProfile organizer;
  @JsonKey(name: 'required_skills')
  final List<SkillResponse> requiredSkills;
  @JsonKey(name: 'oneoff_details')
  final OneOffAdvertDetails? oneoffDetails;
  @JsonKey(name: 'recurring_details')
  final RecurringAdvertDetails? recurringDetails;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  factory AdvertResponse.fromJson(Map<String, dynamic> json) => _$AdvertResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AdvertResponseToJson(this);
}


