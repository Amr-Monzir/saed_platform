import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

@JsonSerializable()
class SkillResponse {
  SkillResponse({required this.id, required this.name, this.category, required this.isPredefined});

  final int id;
  final String name;
  final String? category;
  @JsonKey(name: 'is_predefined')
  final bool isPredefined;

  factory SkillResponse.fromJson(Map<String, dynamic> json) => _$SkillResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SkillResponseToJson(this);
}


