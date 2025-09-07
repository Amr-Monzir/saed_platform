import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer.freezed.dart';
part 'organizer.g.dart';

@freezed
class OrganizerProfile with _$OrganizerProfile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory OrganizerProfile({required int id, required String name, String? logoUrl, String? website, String? description}) =
      _OrganizerProfile;

  OrganizerProfile._();

  factory OrganizerProfile.fromJson(Map<String, dynamic> json) => _$OrganizerProfileFromJson(json);
}

@freezed
class OrganizerProfileSignup with _$OrganizerProfileSignup {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory OrganizerProfileSignup({
    required String name,
    required String logoUrl,
    required String website,
    required String description,
  }) = _OrganizerProfileSignup;

  OrganizerProfileSignup._();

  factory OrganizerProfileSignup.fromJson(Map<String, dynamic> json) => _$OrganizerProfileSignupFromJson(json);
}
