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
  phoneNumber: json['phone_number'] as String?,
  city: json['city'] as String?,
  country: json['country'] as String?,
  onboardingCompleted: json['onboarding_completed'] as bool,
  skills:
      (json['skills'] as List<dynamic>?)
          ?.map((e) => SkillResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  email: json['email'] as String?,
);

Map<String, dynamic> _$$VolunteerProfileImplToJson(
  _$VolunteerProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone_number': instance.phoneNumber,
  'city': instance.city,
  'country': instance.country,
  'onboarding_completed': instance.onboardingCompleted,
  'skills': instance.skills,
  'email': instance.email,
};
