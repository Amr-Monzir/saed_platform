// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizerProfile _$OrganizerProfileFromJson(Map<String, dynamic> json) =>
    OrganizerProfile(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      website: json['website'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$OrganizerProfileToJson(OrganizerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo_url': instance.logoUrl,
      'website': instance.website,
      'description': instance.description,
    };
