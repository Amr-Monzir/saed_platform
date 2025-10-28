// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecurringDaysImpl _$$RecurringDaysImplFromJson(Map<String, dynamic> json) =>
    _$RecurringDaysImpl(
      day: json['day'] as String,
      periods:
          (json['periods'] as List<dynamic>)
              .map((e) => $enumDecode(_$DayTimePeriodEnumMap, e))
              .toList(),
    );

Map<String, dynamic> _$$RecurringDaysImplToJson(
  _$RecurringDaysImpl instance,
) => <String, dynamic>{
  'day': instance.day,
  'periods': instance.periods.map((e) => _$DayTimePeriodEnumMap[e]!).toList(),
};

const _$DayTimePeriodEnumMap = {
  DayTimePeriod.am: 'am',
  DayTimePeriod.pm: 'pm',
  DayTimePeriod.after5pm: 'after5pm',
};

_$RecurringAdvertDetailsImpl _$$RecurringAdvertDetailsImplFromJson(
  Map<String, dynamic> json,
) => _$RecurringAdvertDetailsImpl(
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

Map<String, dynamic> _$$RecurringAdvertDetailsImplToJson(
  _$RecurringAdvertDetailsImpl instance,
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

_$OneOffAdvertDetailsImpl _$$OneOffAdvertDetailsImplFromJson(
  Map<String, dynamic> json,
) => _$OneOffAdvertDetailsImpl(
  eventDatetime: DateTime.parse(json['event_datetime'] as String),
  timeCommitment: $enumDecode(_$TimeCommitmentEnumMap, json['time_commitment']),
  applicationDeadline: DateTime.parse(json['application_deadline'] as String),
);

Map<String, dynamic> _$$OneOffAdvertDetailsImplToJson(
  _$OneOffAdvertDetailsImpl instance,
) => <String, dynamic>{
  'event_datetime': instance.eventDatetime.toIso8601String(),
  'time_commitment': _$TimeCommitmentEnumMap[instance.timeCommitment]!,
  'application_deadline': instance.applicationDeadline.toIso8601String(),
};

_$AdvertImpl _$$AdvertImplFromJson(Map<String, dynamic> json) => _$AdvertImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  frequency: $enumDecode(_$FrequencyTypeEnumMap, json['frequency']),
  numberOfVolunteers: (json['number_of_volunteers'] as num).toInt(),
  locationType: $enumDecode(_$LocationTypeEnumMap, json['location_type']),
  addressText: json['address_text'] as String?,
  postcode: json['postcode'] as String?,
  imageUrl: json['image_url'] as String?,
  city: json['city'] as String?,
  isActive: json['is_active'] as bool,
  organizer: OrganizerProfile.fromJson(
    json['organizer'] as Map<String, dynamic>,
  ),
  requiredSkills:
      (json['required_skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$$AdvertImplToJson(_$AdvertImpl instance) =>
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
      'image_url': instance.imageUrl,
      'city': instance.city,
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
