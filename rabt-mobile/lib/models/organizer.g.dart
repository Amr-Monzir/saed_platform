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
  logoUrl: json['logo_url'] as String?,
  website: json['website'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$OrganizerProfileImplToJson(
  _$OrganizerProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo_url': instance.logoUrl,
  'website': instance.website,
  'description': instance.description,
};

_$OrganizerProfileSignupImpl _$$OrganizerProfileSignupImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizerProfileSignupImpl(
  name: json['name'] as String,
  logoUrl: json['logo_url'] as String,
  website: json['website'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$$OrganizerProfileSignupImplToJson(
  _$OrganizerProfileSignupImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'logo_url': instance.logoUrl,
  'website': instance.website,
  'description': instance.description,
};
