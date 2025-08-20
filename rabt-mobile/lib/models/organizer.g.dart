// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizerResponse _$OrganizerResponseFromJson(Map<String, dynamic> json) =>
    OrganizerResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      website: json['website'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$OrganizerResponseToJson(OrganizerResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo_url': instance.logoUrl,
      'website': instance.website,
      'description': instance.description,
    };
