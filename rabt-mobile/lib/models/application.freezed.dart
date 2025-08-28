// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Application _$ApplicationFromJson(Map<String, dynamic> json) {
  return _Application.fromJson(json);
}

/// @nodoc
mixin _$Application {
  int get id => throw _privateConstructorUsedError;
  int get advertId => throw _privateConstructorUsedError;
  String? get coverMessage => throw _privateConstructorUsedError;
  ApplicationStatus get status => throw _privateConstructorUsedError;
  DateTime get appliedAt => throw _privateConstructorUsedError;
  Advert get advert => throw _privateConstructorUsedError;
  VolunteerProfile? get volunteer => throw _privateConstructorUsedError;
  String? get organizerMessage => throw _privateConstructorUsedError;

  /// Serializes this Application to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationCopyWith<Application> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationCopyWith<$Res> {
  factory $ApplicationCopyWith(
    Application value,
    $Res Function(Application) then,
  ) = _$ApplicationCopyWithImpl<$Res, Application>;
  @useResult
  $Res call({
    int id,
    int advertId,
    String? coverMessage,
    ApplicationStatus status,
    DateTime appliedAt,
    Advert advert,
    VolunteerProfile? volunteer,
    String? organizerMessage,
  });

  $AdvertCopyWith<$Res> get advert;
  $VolunteerProfileCopyWith<$Res>? get volunteer;
}

/// @nodoc
class _$ApplicationCopyWithImpl<$Res, $Val extends Application>
    implements $ApplicationCopyWith<$Res> {
  _$ApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? advertId = null,
    Object? coverMessage = freezed,
    Object? status = null,
    Object? appliedAt = null,
    Object? advert = null,
    Object? volunteer = freezed,
    Object? organizerMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            advertId:
                null == advertId
                    ? _value.advertId
                    : advertId // ignore: cast_nullable_to_non_nullable
                        as int,
            coverMessage:
                freezed == coverMessage
                    ? _value.coverMessage
                    : coverMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as ApplicationStatus,
            appliedAt:
                null == appliedAt
                    ? _value.appliedAt
                    : appliedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            advert:
                null == advert
                    ? _value.advert
                    : advert // ignore: cast_nullable_to_non_nullable
                        as Advert,
            volunteer:
                freezed == volunteer
                    ? _value.volunteer
                    : volunteer // ignore: cast_nullable_to_non_nullable
                        as VolunteerProfile?,
            organizerMessage:
                freezed == organizerMessage
                    ? _value.organizerMessage
                    : organizerMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdvertCopyWith<$Res> get advert {
    return $AdvertCopyWith<$Res>(_value.advert, (value) {
      return _then(_value.copyWith(advert: value) as $Val);
    });
  }

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VolunteerProfileCopyWith<$Res>? get volunteer {
    if (_value.volunteer == null) {
      return null;
    }

    return $VolunteerProfileCopyWith<$Res>(_value.volunteer!, (value) {
      return _then(_value.copyWith(volunteer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApplicationImplCopyWith<$Res>
    implements $ApplicationCopyWith<$Res> {
  factory _$$ApplicationImplCopyWith(
    _$ApplicationImpl value,
    $Res Function(_$ApplicationImpl) then,
  ) = __$$ApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int advertId,
    String? coverMessage,
    ApplicationStatus status,
    DateTime appliedAt,
    Advert advert,
    VolunteerProfile? volunteer,
    String? organizerMessage,
  });

  @override
  $AdvertCopyWith<$Res> get advert;
  @override
  $VolunteerProfileCopyWith<$Res>? get volunteer;
}

/// @nodoc
class __$$ApplicationImplCopyWithImpl<$Res>
    extends _$ApplicationCopyWithImpl<$Res, _$ApplicationImpl>
    implements _$$ApplicationImplCopyWith<$Res> {
  __$$ApplicationImplCopyWithImpl(
    _$ApplicationImpl _value,
    $Res Function(_$ApplicationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? advertId = null,
    Object? coverMessage = freezed,
    Object? status = null,
    Object? appliedAt = null,
    Object? advert = null,
    Object? volunteer = freezed,
    Object? organizerMessage = freezed,
  }) {
    return _then(
      _$ApplicationImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        advertId:
            null == advertId
                ? _value.advertId
                : advertId // ignore: cast_nullable_to_non_nullable
                    as int,
        coverMessage:
            freezed == coverMessage
                ? _value.coverMessage
                : coverMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as ApplicationStatus,
        appliedAt:
            null == appliedAt
                ? _value.appliedAt
                : appliedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        advert:
            null == advert
                ? _value.advert
                : advert // ignore: cast_nullable_to_non_nullable
                    as Advert,
        volunteer:
            freezed == volunteer
                ? _value.volunteer
                : volunteer // ignore: cast_nullable_to_non_nullable
                    as VolunteerProfile?,
        organizerMessage:
            freezed == organizerMessage
                ? _value.organizerMessage
                : organizerMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ApplicationImpl implements _Application {
  const _$ApplicationImpl({
    required this.id,
    required this.advertId,
    this.coverMessage,
    required this.status,
    required this.appliedAt,
    required this.advert,
    this.volunteer,
    this.organizerMessage,
  });

  factory _$ApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationImplFromJson(json);

  @override
  final int id;
  @override
  final int advertId;
  @override
  final String? coverMessage;
  @override
  final ApplicationStatus status;
  @override
  final DateTime appliedAt;
  @override
  final Advert advert;
  @override
  final VolunteerProfile? volunteer;
  @override
  final String? organizerMessage;

  @override
  String toString() {
    return 'Application(id: $id, advertId: $advertId, coverMessage: $coverMessage, status: $status, appliedAt: $appliedAt, advert: $advert, volunteer: $volunteer, organizerMessage: $organizerMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.advertId, advertId) ||
                other.advertId == advertId) &&
            (identical(other.coverMessage, coverMessage) ||
                other.coverMessage == coverMessage) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            (identical(other.advert, advert) || other.advert == advert) &&
            (identical(other.volunteer, volunteer) ||
                other.volunteer == volunteer) &&
            (identical(other.organizerMessage, organizerMessage) ||
                other.organizerMessage == organizerMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    advertId,
    coverMessage,
    status,
    appliedAt,
    advert,
    volunteer,
    organizerMessage,
  );

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationImplCopyWith<_$ApplicationImpl> get copyWith =>
      __$$ApplicationImplCopyWithImpl<_$ApplicationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationImplToJson(this);
  }
}

abstract class _Application implements Application {
  const factory _Application({
    required final int id,
    required final int advertId,
    final String? coverMessage,
    required final ApplicationStatus status,
    required final DateTime appliedAt,
    required final Advert advert,
    final VolunteerProfile? volunteer,
    final String? organizerMessage,
  }) = _$ApplicationImpl;

  factory _Application.fromJson(Map<String, dynamic> json) =
      _$ApplicationImpl.fromJson;

  @override
  int get id;
  @override
  int get advertId;
  @override
  String? get coverMessage;
  @override
  ApplicationStatus get status;
  @override
  DateTime get appliedAt;
  @override
  Advert get advert;
  @override
  VolunteerProfile? get volunteer;
  @override
  String? get organizerMessage;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationImplCopyWith<_$ApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
