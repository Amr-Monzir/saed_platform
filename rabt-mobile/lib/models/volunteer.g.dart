// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolunteerProfile _$VolunteerProfileFromJson(Map<String, dynamic> json) =>
    VolunteerProfile(
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
    );

Map<String, dynamic> _$VolunteerProfileToJson(VolunteerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
      'city': instance.city,
      'country': instance.country,
      'onboarding_completed': instance.onboardingCompleted,
      'skills': instance.skills,
    };
