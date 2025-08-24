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
    json['timeCommitmentPerSession'],
  ),
  duration: $enumDecode(_$DurationTypeEnumMap, json['duration']),
  specificDays:
      (json['specificDays'] as List<dynamic>)
          .map((e) => RecurringDays.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$$RecurringAdvertDetailsImplToJson(
  _$RecurringAdvertDetailsImpl instance,
) => <String, dynamic>{
  'recurrence': _$RecurrenceTypeEnumMap[instance.recurrence]!,
  'timeCommitmentPerSession':
      _$TimeCommitmentEnumMap[instance.timeCommitmentPerSession]!,
  'duration': _$DurationTypeEnumMap[instance.duration]!,
  'specificDays': instance.specificDays,
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
  eventDatetime: DateTime.parse(json['eventDatetime'] as String),
  timeCommitment: $enumDecode(_$TimeCommitmentEnumMap, json['timeCommitment']),
  applicationDeadline: DateTime.parse(json['applicationDeadline'] as String),
);

Map<String, dynamic> _$$OneOffAdvertDetailsImplToJson(
  _$OneOffAdvertDetailsImpl instance,
) => <String, dynamic>{
  'eventDatetime': instance.eventDatetime.toIso8601String(),
  'timeCommitment': _$TimeCommitmentEnumMap[instance.timeCommitment]!,
  'applicationDeadline': instance.applicationDeadline.toIso8601String(),
};

_$AdvertImpl _$$AdvertImplFromJson(Map<String, dynamic> json) => _$AdvertImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  frequency: $enumDecode(_$FrequencyTypeEnumMap, json['frequency']),
  numberOfVolunteers: (json['numberOfVolunteers'] as num).toInt(),
  locationType: $enumDecode(_$LocationTypeEnumMap, json['locationType']),
  addressText: json['addressText'] as String?,
  postcode: json['postcode'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  advertImageUrl: json['advertImageUrl'] as String?,
  isActive: json['isActive'] as bool,
  organizer: OrganizerProfile.fromJson(
    json['organizer'] as Map<String, dynamic>,
  ),
  requiredSkills:
      (json['requiredSkills'] as List<dynamic>?)
          ?.map((e) => SkillResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  oneoffDetails:
      json['oneoffDetails'] == null
          ? null
          : OneOffAdvertDetails.fromJson(
            json['oneoffDetails'] as Map<String, dynamic>,
          ),
  recurringDetails:
      json['recurringDetails'] == null
          ? null
          : RecurringAdvertDetails.fromJson(
            json['recurringDetails'] as Map<String, dynamic>,
          ),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$AdvertImplToJson(_$AdvertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'frequency': _$FrequencyTypeEnumMap[instance.frequency]!,
      'numberOfVolunteers': instance.numberOfVolunteers,
      'locationType': _$LocationTypeEnumMap[instance.locationType]!,
      'addressText': instance.addressText,
      'postcode': instance.postcode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'advertImageUrl': instance.advertImageUrl,
      'isActive': instance.isActive,
      'organizer': instance.organizer,
      'requiredSkills': instance.requiredSkills,
      'oneoffDetails': instance.oneoffDetails,
      'recurringDetails': instance.recurringDetails,
      'createdAt': instance.createdAt.toIso8601String(),
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
