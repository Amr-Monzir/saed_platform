// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  userType: $enumDecode(_$UserTypeEnumMap, json['user_type']),
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'user_type': _$UserTypeEnumMap[instance.userType]!,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$UserTypeEnumMap = {
  UserType.volunteer: 'volunteer',
  UserType.organizer: 'organizer',
};

_$TokenImpl _$$TokenImplFromJson(Map<String, dynamic> json) => _$TokenImpl(
  accessToken: json['access_token'] as String,
  tokenType: json['token_type'] as String,
  refreshToken: json['refresh_token'] as String?,
  expiresIn: (json['expires_in'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TokenImplToJson(_$TokenImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
    };

_$TokenDataImpl _$$TokenDataImplFromJson(Map<String, dynamic> json) =>
    _$TokenDataImpl(email: json['email'] as String?);

Map<String, dynamic> _$$TokenDataImplToJson(_$TokenDataImpl instance) =>
    <String, dynamic>{'email': instance.email};
