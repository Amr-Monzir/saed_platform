// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionDataImpl _$$SessionDataImplFromJson(Map<String, dynamic> json) =>
    _$SessionDataImpl(
      token: json['token'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      pendingAdvertId: json['pendingAdvertId'] as String?,
      organizerProfile:
          json['organizerProfile'] == null
              ? null
              : OrganizerProfile.fromJson(
                json['organizerProfile'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$$SessionDataImplToJson(_$SessionDataImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'pendingAdvertId': instance.pendingAdvertId,
      'organizerProfile': instance.organizerProfile,
    };

const _$UserTypeEnumMap = {
  UserType.volunteer: 'volunteer',
  UserType.organizer: 'organizer',
};
