import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'advert.dart';
import 'volunteer.dart';

part 'application.freezed.dart';
part 'application.g.dart';

@freezed
class Application with _$Application {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Application({
    required int id,
    required int advertId,
    String? coverMessage,
    required ApplicationStatus status,
    required DateTime appliedAt,
    required Advert advert,
    VolunteerProfile? volunteer,
    String? organizerMessage,
  }) = _Application;

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);
}


