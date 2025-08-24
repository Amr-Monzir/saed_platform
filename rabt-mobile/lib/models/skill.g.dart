// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkillResponseImpl _$$SkillResponseImplFromJson(Map<String, dynamic> json) =>
    _$SkillResponseImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String?,
      isPredefined: json['isPredefined'] as bool,
    );

Map<String, dynamic> _$$SkillResponseImplToJson(_$SkillResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'isPredefined': instance.isPredefined,
    };
