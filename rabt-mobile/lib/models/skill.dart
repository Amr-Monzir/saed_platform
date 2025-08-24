import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill.freezed.dart';
part 'skill.g.dart';

@freezed
class SkillResponse with _$SkillResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SkillResponse({
    required int id,
    required String name,
    String? category,
    required bool isPredefined,
  }) = _SkillResponse;

  factory SkillResponse.fromJson(Map<String, dynamic> json) => _$SkillResponseFromJson(json);
}


