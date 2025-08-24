// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organizer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrganizerProfile _$OrganizerProfileFromJson(Map<String, dynamic> json) {
  return _OrganizerProfile.fromJson(json);
}

/// @nodoc
mixin _$OrganizerProfile {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this OrganizerProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrganizerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizerProfileCopyWith<OrganizerProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerProfileCopyWith<$Res> {
  factory $OrganizerProfileCopyWith(
    OrganizerProfile value,
    $Res Function(OrganizerProfile) then,
  ) = _$OrganizerProfileCopyWithImpl<$Res, OrganizerProfile>;
  @useResult
  $Res call({
    int id,
    String name,
    String? logoUrl,
    String? website,
    String? description,
  });
}

/// @nodoc
class _$OrganizerProfileCopyWithImpl<$Res, $Val extends OrganizerProfile>
    implements $OrganizerProfileCopyWith<$Res> {
  _$OrganizerProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? website = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            logoUrl:
                freezed == logoUrl
                    ? _value.logoUrl
                    : logoUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            website:
                freezed == website
                    ? _value.website
                    : website // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrganizerProfileImplCopyWith<$Res>
    implements $OrganizerProfileCopyWith<$Res> {
  factory _$$OrganizerProfileImplCopyWith(
    _$OrganizerProfileImpl value,
    $Res Function(_$OrganizerProfileImpl) then,
  ) = __$$OrganizerProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? logoUrl,
    String? website,
    String? description,
  });
}

/// @nodoc
class __$$OrganizerProfileImplCopyWithImpl<$Res>
    extends _$OrganizerProfileCopyWithImpl<$Res, _$OrganizerProfileImpl>
    implements _$$OrganizerProfileImplCopyWith<$Res> {
  __$$OrganizerProfileImplCopyWithImpl(
    _$OrganizerProfileImpl _value,
    $Res Function(_$OrganizerProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrganizerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? website = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$OrganizerProfileImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        logoUrl:
            freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        website:
            freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$OrganizerProfileImpl extends _OrganizerProfile {
  _$OrganizerProfileImpl({
    required this.id,
    required this.name,
    this.logoUrl,
    this.website,
    this.description,
  }) : super._();

  factory _$OrganizerProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerProfileImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final String? website;
  @override
  final String? description;

  @override
  String toString() {
    return 'OrganizerProfile(id: $id, name: $name, logoUrl: $logoUrl, website: $website, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, logoUrl, website, description);

  /// Create a copy of OrganizerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerProfileImplCopyWith<_$OrganizerProfileImpl> get copyWith =>
      __$$OrganizerProfileImplCopyWithImpl<_$OrganizerProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerProfileImplToJson(this);
  }
}

abstract class _OrganizerProfile extends OrganizerProfile {
  factory _OrganizerProfile({
    required final int id,
    required final String name,
    final String? logoUrl,
    final String? website,
    final String? description,
  }) = _$OrganizerProfileImpl;
  _OrganizerProfile._() : super._();

  factory _OrganizerProfile.fromJson(Map<String, dynamic> json) =
      _$OrganizerProfileImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get logoUrl;
  @override
  String? get website;
  @override
  String? get description;

  /// Create a copy of OrganizerProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizerProfileImplCopyWith<_$OrganizerProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
