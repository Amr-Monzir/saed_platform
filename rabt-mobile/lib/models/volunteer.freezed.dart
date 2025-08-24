// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'volunteer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VolunteerProfile _$VolunteerProfileFromJson(Map<String, dynamic> json) {
  return _VolunteerProfile.fromJson(json);
}

/// @nodoc
mixin _$VolunteerProfile {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  bool get onboardingCompleted => throw _privateConstructorUsedError;
  List<SkillResponse> get skills => throw _privateConstructorUsedError;

  /// Serializes this VolunteerProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VolunteerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VolunteerProfileCopyWith<VolunteerProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VolunteerProfileCopyWith<$Res> {
  factory $VolunteerProfileCopyWith(
    VolunteerProfile value,
    $Res Function(VolunteerProfile) then,
  ) = _$VolunteerProfileCopyWithImpl<$Res, VolunteerProfile>;
  @useResult
  $Res call({
    int id,
    String name,
    String? phoneNumber,
    String? city,
    String? country,
    bool onboardingCompleted,
    List<SkillResponse> skills,
  });
}

/// @nodoc
class _$VolunteerProfileCopyWithImpl<$Res, $Val extends VolunteerProfile>
    implements $VolunteerProfileCopyWith<$Res> {
  _$VolunteerProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VolunteerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phoneNumber = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? onboardingCompleted = null,
    Object? skills = null,
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
            phoneNumber:
                freezed == phoneNumber
                    ? _value.phoneNumber
                    : phoneNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            city:
                freezed == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String?,
            country:
                freezed == country
                    ? _value.country
                    : country // ignore: cast_nullable_to_non_nullable
                        as String?,
            onboardingCompleted:
                null == onboardingCompleted
                    ? _value.onboardingCompleted
                    : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                        as bool,
            skills:
                null == skills
                    ? _value.skills
                    : skills // ignore: cast_nullable_to_non_nullable
                        as List<SkillResponse>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VolunteerProfileImplCopyWith<$Res>
    implements $VolunteerProfileCopyWith<$Res> {
  factory _$$VolunteerProfileImplCopyWith(
    _$VolunteerProfileImpl value,
    $Res Function(_$VolunteerProfileImpl) then,
  ) = __$$VolunteerProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? phoneNumber,
    String? city,
    String? country,
    bool onboardingCompleted,
    List<SkillResponse> skills,
  });
}

/// @nodoc
class __$$VolunteerProfileImplCopyWithImpl<$Res>
    extends _$VolunteerProfileCopyWithImpl<$Res, _$VolunteerProfileImpl>
    implements _$$VolunteerProfileImplCopyWith<$Res> {
  __$$VolunteerProfileImplCopyWithImpl(
    _$VolunteerProfileImpl _value,
    $Res Function(_$VolunteerProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VolunteerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phoneNumber = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? onboardingCompleted = null,
    Object? skills = null,
  }) {
    return _then(
      _$VolunteerProfileImpl(
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
        phoneNumber:
            freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        city:
            freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String?,
        country:
            freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                    as String?,
        onboardingCompleted:
            null == onboardingCompleted
                ? _value.onboardingCompleted
                : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                    as bool,
        skills:
            null == skills
                ? _value._skills
                : skills // ignore: cast_nullable_to_non_nullable
                    as List<SkillResponse>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$VolunteerProfileImpl implements _VolunteerProfile {
  const _$VolunteerProfileImpl({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.city,
    this.country,
    required this.onboardingCompleted,
    final List<SkillResponse> skills = const [],
  }) : _skills = skills;

  factory _$VolunteerProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$VolunteerProfileImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? phoneNumber;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final bool onboardingCompleted;
  final List<SkillResponse> _skills;
  @override
  @JsonKey()
  List<SkillResponse> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  String toString() {
    return 'VolunteerProfile(id: $id, name: $name, phoneNumber: $phoneNumber, city: $city, country: $country, onboardingCompleted: $onboardingCompleted, skills: $skills)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VolunteerProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            const DeepCollectionEquality().equals(other._skills, _skills));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    phoneNumber,
    city,
    country,
    onboardingCompleted,
    const DeepCollectionEquality().hash(_skills),
  );

  /// Create a copy of VolunteerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VolunteerProfileImplCopyWith<_$VolunteerProfileImpl> get copyWith =>
      __$$VolunteerProfileImplCopyWithImpl<_$VolunteerProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VolunteerProfileImplToJson(this);
  }
}

abstract class _VolunteerProfile implements VolunteerProfile {
  const factory _VolunteerProfile({
    required final int id,
    required final String name,
    final String? phoneNumber,
    final String? city,
    final String? country,
    required final bool onboardingCompleted,
    final List<SkillResponse> skills,
  }) = _$VolunteerProfileImpl;

  factory _VolunteerProfile.fromJson(Map<String, dynamic> json) =
      _$VolunteerProfileImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get phoneNumber;
  @override
  String? get city;
  @override
  String? get country;
  @override
  bool get onboardingCompleted;
  @override
  List<SkillResponse> get skills;

  /// Create a copy of VolunteerProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VolunteerProfileImplCopyWith<_$VolunteerProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
