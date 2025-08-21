import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';
import 'advert.dart';
import 'volunteer.dart';

part 'application.g.dart';

@JsonSerializable()
class Application {
  Application({
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
  final Advert advert;
  final VolunteerProfile? volunteer;

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}


