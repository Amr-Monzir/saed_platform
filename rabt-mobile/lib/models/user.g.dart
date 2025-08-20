// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  userType: $enumDecode(_$UserTypeEnumMap, json['user_type']),
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
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

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  accessToken: json['access_token'] as String,
  tokenType: json['token_type'] as String,
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'token_type': instance.tokenType,
};

TokenData _$TokenDataFromJson(Map<String, dynamic> json) =>
    TokenData(email: json['email'] as String?);

Map<String, dynamic> _$TokenDataToJson(TokenData instance) => <String, dynamic>{
  'email': instance.email,
};
