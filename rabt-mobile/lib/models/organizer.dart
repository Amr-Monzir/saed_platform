import 'package:json_annotation/json_annotation.dart';

part 'organizer.g.dart';

@JsonSerializable()
class OrganizerResponse {
  OrganizerResponse({required this.id, required this.name, this.logoUrl, this.website, this.description});

  final int id;
  final String name;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  final String? website;
  final String? description;

  factory OrganizerResponse.fromJson(Map<String, dynamic> json) => _$OrganizerResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizerResponseToJson(this);
}


