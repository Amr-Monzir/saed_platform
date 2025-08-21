import 'package:json_annotation/json_annotation.dart';
import 'skill.dart';

part 'volunteer.g.dart';

@JsonSerializable()
class VolunteerProfile {
  VolunteerProfile({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.city,
    this.country,
    required this.onboardingCompleted,
    this.skills = const [],
  });

  final int id;
  final String name;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? city;
  final String? country;
  @JsonKey(name: 'onboarding_completed')
  final bool onboardingCompleted;
  final List<SkillResponse> skills;

  factory VolunteerProfile.fromJson(Map<String, dynamic> json) => _$VolunteerProfileFromJson(json);
  Map<String, dynamic> toJson() => _$VolunteerProfileToJson(this);
}


