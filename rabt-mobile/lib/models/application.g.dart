// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationResponse _$ApplicationResponseFromJson(Map<String, dynamic> json) =>
    ApplicationResponse(
      id: (json['id'] as num).toInt(),
      advertId: (json['advert_id'] as num).toInt(),
      coverMessage: json['cover_message'] as String?,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      appliedAt: DateTime.parse(json['applied_at'] as String),
      advert: AdvertResponse.fromJson(json['advert'] as Map<String, dynamic>),
      volunteer:
          json['volunteer'] == null
              ? null
              : VolunteerProfile.fromJson(
                json['volunteer'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$ApplicationResponseToJson(
  ApplicationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'advert_id': instance.advertId,
  'cover_message': instance.coverMessage,
  'status': _$ApplicationStatusEnumMap[instance.status]!,
  'applied_at': instance.appliedAt.toIso8601String(),
  'advert': instance.advert,
  'volunteer': instance.volunteer,
};

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.pending: 'pending',
  ApplicationStatus.accepted: 'accepted',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.withdrawn: 'withdrawn',
};
