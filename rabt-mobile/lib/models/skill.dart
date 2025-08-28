import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill.freezed.dart';
part 'skill.g.dart';

@freezed
class Skill with _$Skill {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Skill({
    required int id,
    required String name,
    String? category,
    required bool isPredefined,
  }) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}


