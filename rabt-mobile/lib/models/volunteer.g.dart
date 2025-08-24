// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VolunteerProfileImpl _$$VolunteerProfileImplFromJson(
  Map<String, dynamic> json,
) => _$VolunteerProfileImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  city: json['city'] as String?,
  country: json['country'] as String?,
  onboardingCompleted: json['onboardingCompleted'] as bool,
  skills:
      (json['skills'] as List<dynamic>?)
          ?.map((e) => SkillResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$VolunteerProfileImplToJson(
  _$VolunteerProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'city': instance.city,
  'country': instance.country,
  'onboardingCompleted': instance.onboardingCompleted,
  'skills': instance.skills,
};
