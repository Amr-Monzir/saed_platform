// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizerProfileImpl _$$OrganizerProfileImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizerProfileImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  logoUrl: json['logoUrl'] as String?,
  website: json['website'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$OrganizerProfileImplToJson(
  _$OrganizerProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logoUrl': instance.logoUrl,
  'website': instance.website,
  'description': instance.description,
};
