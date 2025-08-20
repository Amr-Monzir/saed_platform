// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillResponse _$SkillResponseFromJson(Map<String, dynamic> json) =>
    SkillResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String?,
      isPredefined: json['is_predefined'] as bool,
    );

Map<String, dynamic> _$SkillResponseToJson(SkillResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'is_predefined': instance.isPredefined,
    };
