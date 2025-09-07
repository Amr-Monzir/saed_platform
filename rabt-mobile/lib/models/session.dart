import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/models/organizer.dart';
import 'package:rabt_mobile/models/volunteer.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class SessionData with _$SessionData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SessionData({
    required String token,
    required UserType userType,
    String? pendingAdvertId,
    OrganizerProfile? organizerProfile,
    VolunteerProfile? volunteerProfile,
    String? refreshToken, // Add refresh token field
  }) = _SessionData;

  factory SessionData.fromJson(Map<String, dynamic> json) => _$SessionDataFromJson(json);
}
