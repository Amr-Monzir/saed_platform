import 'package:json_annotation/json_annotation.dart';

part 'organizer.g.dart';

@JsonSerializable()
class OrganizerProfile {
  OrganizerProfile({required this.id, required this.name, this.logoUrl, this.website, this.description});

  final int id;
  final String name;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  final String? website;
  final String? description;

  factory OrganizerProfile.fromJson(Map<String, dynamic> json) => _$OrganizerProfileFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizerProfileToJson(this);
}


