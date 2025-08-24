// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationImpl _$$ApplicationImplFromJson(Map<String, dynamic> json) =>
    _$ApplicationImpl(
      id: (json['id'] as num).toInt(),
      advertId: (json['advertId'] as num).toInt(),
      coverMessage: json['coverMessage'] as String?,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      appliedAt: DateTime.parse(json['appliedAt'] as String),
      advert: Advert.fromJson(json['advert'] as Map<String, dynamic>),
      volunteer:
          json['volunteer'] == null
              ? null
              : VolunteerProfile.fromJson(
                json['volunteer'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$$ApplicationImplToJson(_$ApplicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'advertId': instance.advertId,
      'coverMessage': instance.coverMessage,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'appliedAt': instance.appliedAt.toIso8601String(),
      'advert': instance.advert,
      'volunteer': instance.volunteer,
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.pending: 'pending',
  ApplicationStatus.accepted: 'accepted',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.withdrawn: 'withdrawn',
};
