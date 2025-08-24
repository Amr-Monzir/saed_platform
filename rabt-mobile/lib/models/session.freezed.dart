// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionData _$SessionDataFromJson(Map<String, dynamic> json) {
  return _SessionData.fromJson(json);
}

/// @nodoc
mixin _$SessionData {
  String get token => throw _privateConstructorUsedError;
  UserType get userType => throw _privateConstructorUsedError;
  String? get pendingAdvertId => throw _privateConstructorUsedError;
  OrganizerProfile? get organizerProfile => throw _privateConstructorUsedError;

  /// Serializes this SessionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionDataCopyWith<SessionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionDataCopyWith<$Res> {
  factory $SessionDataCopyWith(
    SessionData value,
    $Res Function(SessionData) then,
  ) = _$SessionDataCopyWithImpl<$Res, SessionData>;
  @useResult
  $Res call({
    String token,
    UserType userType,
    String? pendingAdvertId,
    OrganizerProfile? organizerProfile,
  });

  $OrganizerProfileCopyWith<$Res>? get organizerProfile;
}

/// @nodoc
class _$SessionDataCopyWithImpl<$Res, $Val extends SessionData>
    implements $SessionDataCopyWith<$Res> {
  _$SessionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userType = null,
    Object? pendingAdvertId = freezed,
    Object? organizerProfile = freezed,
  }) {
    return _then(
      _value.copyWith(
            token:
                null == token
                    ? _value.token
                    : token // ignore: cast_nullable_to_non_nullable
                        as String,
            userType:
                null == userType
                    ? _value.userType
                    : userType // ignore: cast_nullable_to_non_nullable
                        as UserType,
            pendingAdvertId:
                freezed == pendingAdvertId
                    ? _value.pendingAdvertId
                    : pendingAdvertId // ignore: cast_nullable_to_non_nullable
                        as String?,
            organizerProfile:
                freezed == organizerProfile
                    ? _value.organizerProfile
                    : organizerProfile // ignore: cast_nullable_to_non_nullable
                        as OrganizerProfile?,
          )
          as $Val,
    );
  }

  /// Create a copy of SessionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizerProfileCopyWith<$Res>? get organizerProfile {
    if (_value.organizerProfile == null) {
      return null;
    }

    return $OrganizerProfileCopyWith<$Res>(_value.organizerProfile!, (value) {
      return _then(_value.copyWith(organizerProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionDataImplCopyWith<$Res>
    implements $SessionDataCopyWith<$Res> {
  factory _$$SessionDataImplCopyWith(
    _$SessionDataImpl value,
    $Res Function(_$SessionDataImpl) then,
  ) = __$$SessionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    UserType userType,
    String? pendingAdvertId,
    OrganizerProfile? organizerProfile,
  });

  @override
  $OrganizerProfileCopyWith<$Res>? get organizerProfile;
}

/// @nodoc
class __$$SessionDataImplCopyWithImpl<$Res>
    extends _$SessionDataCopyWithImpl<$Res, _$SessionDataImpl>
    implements _$$SessionDataImplCopyWith<$Res> {
  __$$SessionDataImplCopyWithImpl(
    _$SessionDataImpl _value,
    $Res Function(_$SessionDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userType = null,
    Object? pendingAdvertId = freezed,
    Object? organizerProfile = freezed,
  }) {
    return _then(
      _$SessionDataImpl(
        token:
            null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                    as String,
        userType:
            null == userType
                ? _value.userType
                : userType // ignore: cast_nullable_to_non_nullable
                    as UserType,
        pendingAdvertId:
            freezed == pendingAdvertId
                ? _value.pendingAdvertId
                : pendingAdvertId // ignore: cast_nullable_to_non_nullable
                    as String?,
        organizerProfile:
            freezed == organizerProfile
                ? _value.organizerProfile
                : organizerProfile // ignore: cast_nullable_to_non_nullable
                    as OrganizerProfile?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionDataImpl implements _SessionData {
  const _$SessionDataImpl({
    required this.token,
    required this.userType,
    this.pendingAdvertId,
    this.organizerProfile,
  });

  factory _$SessionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionDataImplFromJson(json);

  @override
  final String token;
  @override
  final UserType userType;
  @override
  final String? pendingAdvertId;
  @override
  final OrganizerProfile? organizerProfile;

  @override
  String toString() {
    return 'SessionData(token: $token, userType: $userType, pendingAdvertId: $pendingAdvertId, organizerProfile: $organizerProfile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionDataImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.pendingAdvertId, pendingAdvertId) ||
                other.pendingAdvertId == pendingAdvertId) &&
            (identical(other.organizerProfile, organizerProfile) ||
                other.organizerProfile == organizerProfile));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    token,
    userType,
    pendingAdvertId,
    organizerProfile,
  );

  /// Create a copy of SessionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionDataImplCopyWith<_$SessionDataImpl> get copyWith =>
      __$$SessionDataImplCopyWithImpl<_$SessionDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionDataImplToJson(this);
  }
}

abstract class _SessionData implements SessionData {
  const factory _SessionData({
    required final String token,
    required final UserType userType,
    final String? pendingAdvertId,
    final OrganizerProfile? organizerProfile,
  }) = _$SessionDataImpl;

  factory _SessionData.fromJson(Map<String, dynamic> json) =
      _$SessionDataImpl.fromJson;

  @override
  String get token;
  @override
  UserType get userType;
  @override
  String? get pendingAdvertId;
  @override
  OrganizerProfile? get organizerProfile;

  /// Create a copy of SessionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionDataImplCopyWith<_$SessionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
