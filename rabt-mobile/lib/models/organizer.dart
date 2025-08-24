import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer.freezed.dart';
part 'organizer.g.dart';

@freezed
class OrganizerProfile with _$OrganizerProfile {
  const factory OrganizerProfile({required int id, required String name, String? logoUrl, String? website, String? description}) =
      _OrganizerProfile;

  factory OrganizerProfile.fromJson(Map<String, dynamic> json) => _$OrganizerProfileFromJson(json);
}
