import 'package:freezed_annotation/freezed_annotation.dart';
import 'skill.dart';

part 'volunteer.freezed.dart';
part 'volunteer.g.dart';

@freezed
class VolunteerProfile with _$VolunteerProfile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory VolunteerProfile({
    required int id,
    required String name,
    String? phoneNumber,
    String? city,
    String? country,
    required bool onboardingCompleted,
    @Default([]) List<SkillResponse> skills,
  }) = _VolunteerProfile;

  factory VolunteerProfile.fromJson(Map<String, dynamic> json) => _$VolunteerProfileFromJson(json);
}


