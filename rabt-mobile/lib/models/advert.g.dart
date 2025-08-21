// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringDays _$RecurringDaysFromJson(Map<String, dynamic> json) =>
    RecurringDays(
      day: json['day'] as String,
      periods:
          (json['periods'] as List<dynamic>)
              .map((e) => $enumDecode(_$DayTimePeriodEnumMap, e))
              .toList(),
    );

Map<String, dynamic> _$RecurringDaysToJson(
  RecurringDays instance,
) => <String, dynamic>{
  'day': instance.day,
  'periods': instance.periods.map((e) => _$DayTimePeriodEnumMap[e]!).toList(),
};

const _$DayTimePeriodEnumMap = {
  DayTimePeriod.am: 'am',
  DayTimePeriod.pm: 'pm',
  DayTimePeriod.after5pm: 'after5pm',
};

RecurringAdvertDetails _$RecurringAdvertDetailsFromJson(
  Map<String, dynamic> json,
) => RecurringAdvertDetails(
  recurrence: $enumDecode(_$RecurrenceTypeEnumMap, json['recurrence']),
  timeCommitmentPerSession: $enumDecode(
    _$TimeCommitmentEnumMap,
    json['time_commitment_per_session'],
  ),
  duration: $enumDecode(_$DurationTypeEnumMap, json['duration']),
  specificDays:
      (json['specific_days'] as List<dynamic>)
          .map((e) => RecurringDays.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$RecurringAdvertDetailsToJson(
  RecurringAdvertDetails instance,
) => <String, dynamic>{
  'recurrence': _$RecurrenceTypeEnumMap[instance.recurrence]!,
  'time_commitment_per_session':
      _$TimeCommitmentEnumMap[instance.timeCommitmentPerSession]!,
  'duration': _$DurationTypeEnumMap[instance.duration]!,
  'specific_days': instance.specificDays,
};

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.weekly: 'weekly',
  RecurrenceType.biWeekly: 'bi-weekly',
  RecurrenceType.monthly: 'monthly',
};

const _$TimeCommitmentEnumMap = {
  TimeCommitment.oneToTwo: '1-2h',
  TimeCommitment.threeToFive: '3-5h',
  TimeCommitment.sixToTen: '6-10h',
  TimeCommitment.tenPlus: '10+h',
};

const _$DurationTypeEnumMap = {
  DurationType.oneMonth: '1month',
  DurationType.threeMonths: '3months',
  DurationType.sixMonths: '6months',
  DurationType.ongoing: 'ongoing',
};

OneOffAdvertDetails _$OneOffAdvertDetailsFromJson(
  Map<String, dynamic> json,
) => OneOffAdvertDetails(
  eventDatetime: DateTime.parse(json['event_datetime'] as String),
  timeCommitment: $enumDecode(_$TimeCommitmentEnumMap, json['time_commitment']),
  applicationDeadline: DateTime.parse(json['application_deadline'] as String),
);

Map<String, dynamic> _$OneOffAdvertDetailsToJson(
  OneOffAdvertDetails instance,
) => <String, dynamic>{
  'event_datetime': instance.eventDatetime.toIso8601String(),
  'time_commitment': _$TimeCommitmentEnumMap[instance.timeCommitment]!,
  'application_deadline': instance.applicationDeadline.toIso8601String(),
};

AdvertResponse _$AdvertResponseFromJson(Map<String, dynamic> json) =>
    AdvertResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      frequency: $enumDecode(_$FrequencyTypeEnumMap, json['frequency']),
      numberOfVolunteers: (json['number_of_volunteers'] as num).toInt(),
      locationType: $enumDecode(_$LocationTypeEnumMap, json['location_type']),
      addressText: json['address_text'] as String?,
      postcode: json['postcode'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      advertImageUrl: json['advert_image_url'] as String?,
      isActive: json['is_active'] as bool,
      organizer: OrganizerProfile.fromJson(
        json['organizer'] as Map<String, dynamic>,
      ),
      requiredSkills:
          (json['required_skills'] as List<dynamic>?)
              ?.map((e) => SkillResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      oneoffDetails:
          json['oneoff_details'] == null
              ? null
              : OneOffAdvertDetails.fromJson(
                json['oneoff_details'] as Map<String, dynamic>,
              ),
      recurringDetails:
          json['recurring_details'] == null
              ? null
              : RecurringAdvertDetails.fromJson(
                json['recurring_details'] as Map<String, dynamic>,
              ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AdvertResponseToJson(AdvertResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'frequency': _$FrequencyTypeEnumMap[instance.frequency]!,
      'number_of_volunteers': instance.numberOfVolunteers,
      'location_type': _$LocationTypeEnumMap[instance.locationType]!,
      'address_text': instance.addressText,
      'postcode': instance.postcode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'advert_image_url': instance.advertImageUrl,
      'is_active': instance.isActive,
      'organizer': instance.organizer,
      'required_skills': instance.requiredSkills,
      'oneoff_details': instance.oneoffDetails,
      'recurring_details': instance.recurringDetails,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$FrequencyTypeEnumMap = {
  FrequencyType.oneOff: 'one-off',
  FrequencyType.recurring: 'recurring',
};

const _$LocationTypeEnumMap = {
  LocationType.remote: 'remote',
  LocationType.hybrid: 'hybrid',
  LocationType.onSite: 'on-site',
};
