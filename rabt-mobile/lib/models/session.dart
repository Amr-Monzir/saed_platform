import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/models/organizer.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class SessionData with _$SessionData {
  const factory SessionData({
    required String token,
    required UserType userType,
    String? pendingAdvertId,
    OrganizerProfile? organizerProfile,
  }) = _SessionData;

  factory SessionData.fromJson(Map<String, dynamic> json) => _$SessionDataFromJson(json);
}
