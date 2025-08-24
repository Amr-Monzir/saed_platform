// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SkillResponse _$SkillResponseFromJson(Map<String, dynamic> json) {
  return _SkillResponse.fromJson(json);
}

/// @nodoc
mixin _$SkillResponse {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool get isPredefined => throw _privateConstructorUsedError;

  /// Serializes this SkillResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillResponseCopyWith<SkillResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillResponseCopyWith<$Res> {
  factory $SkillResponseCopyWith(
    SkillResponse value,
    $Res Function(SkillResponse) then,
  ) = _$SkillResponseCopyWithImpl<$Res, SkillResponse>;
  @useResult
  $Res call({int id, String name, String? category, bool isPredefined});
}

/// @nodoc
class _$SkillResponseCopyWithImpl<$Res, $Val extends SkillResponse>
    implements $SkillResponseCopyWith<$Res> {
  _$SkillResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = freezed,
    Object? isPredefined = null,
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
            category:
                freezed == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String?,
            isPredefined:
                null == isPredefined
                    ? _value.isPredefined
                    : isPredefined // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SkillResponseImplCopyWith<$Res>
    implements $SkillResponseCopyWith<$Res> {
  factory _$$SkillResponseImplCopyWith(
    _$SkillResponseImpl value,
    $Res Function(_$SkillResponseImpl) then,
  ) = __$$SkillResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String? category, bool isPredefined});
}

/// @nodoc
class __$$SkillResponseImplCopyWithImpl<$Res>
    extends _$SkillResponseCopyWithImpl<$Res, _$SkillResponseImpl>
    implements _$$SkillResponseImplCopyWith<$Res> {
  __$$SkillResponseImplCopyWithImpl(
    _$SkillResponseImpl _value,
    $Res Function(_$SkillResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = freezed,
    Object? isPredefined = null,
  }) {
    return _then(
      _$SkillResponseImpl(
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
        category:
            freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String?,
        isPredefined:
            null == isPredefined
                ? _value.isPredefined
                : isPredefined // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillResponseImpl implements _SkillResponse {
  const _$SkillResponseImpl({
    required this.id,
    required this.name,
    this.category,
    required this.isPredefined,
  });

  factory _$SkillResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? category;
  @override
  final bool isPredefined;

  @override
  String toString() {
    return 'SkillResponse(id: $id, name: $name, category: $category, isPredefined: $isPredefined)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isPredefined, isPredefined) ||
                other.isPredefined == isPredefined));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, category, isPredefined);

  /// Create a copy of SkillResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillResponseImplCopyWith<_$SkillResponseImpl> get copyWith =>
      __$$SkillResponseImplCopyWithImpl<_$SkillResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillResponseImplToJson(this);
  }
}

abstract class _SkillResponse implements SkillResponse {
  const factory _SkillResponse({
    required final int id,
    required final String name,
    final String? category,
    required final bool isPredefined,
  }) = _$SkillResponseImpl;

  factory _SkillResponse.fromJson(Map<String, dynamic> json) =
      _$SkillResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get category;
  @override
  bool get isPredefined;

  /// Create a copy of SkillResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillResponseImplCopyWith<_$SkillResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
