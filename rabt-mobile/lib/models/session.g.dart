// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionDataImpl _$$SessionDataImplFromJson(Map<String, dynamic> json) =>
    _$SessionDataImpl(
      token: json['token'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['user_type']),
      pendingAdvertId: json['pending_advert_id'] as String?,
      organizerProfile:
          json['organizer_profile'] == null
              ? null
              : OrganizerProfile.fromJson(
                json['organizer_profile'] as Map<String, dynamic>,
              ),
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$$SessionDataImplToJson(_$SessionDataImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user_type': _$UserTypeEnumMap[instance.userType]!,
      'pending_advert_id': instance.pendingAdvertId,
      'organizer_profile': instance.organizerProfile,
      'refresh_token': instance.refreshToken,
    };

const _$UserTypeEnumMap = {
  UserType.volunteer: 'volunteer',
  UserType.organizer: 'organizer',
};
