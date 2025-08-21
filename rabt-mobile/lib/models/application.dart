import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';
import 'advert.dart';
import 'volunteer.dart';

part 'application.g.dart';

@JsonSerializable()
class ApplicationResponse {
  ApplicationResponse({
    required this.id,
    required this.advertId,
    this.coverMessage,
    required this.status,
    required this.appliedAt,
    required this.advert,
    this.volunteer,
  });

  final int id;
  @JsonKey(name: 'advert_id')
  final int advertId;
  @JsonKey(name: 'cover_message')
  final String? coverMessage;
  final ApplicationStatus status;
  @JsonKey(name: 'applied_at')
  final DateTime appliedAt;
  final AdvertResponse advert;
  final VolunteerProfile? volunteer;

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) => _$ApplicationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationResponseToJson(this);
}


