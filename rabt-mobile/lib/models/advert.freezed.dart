// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecurringDays _$RecurringDaysFromJson(Map<String, dynamic> json) {
  return _RecurringDays.fromJson(json);
}

/// @nodoc
mixin _$RecurringDays {
  String get day =>
      throw _privateConstructorUsedError; // backend uses string day key
  List<DayTimePeriod> get periods => throw _privateConstructorUsedError;

  /// Serializes this RecurringDays to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringDays
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringDaysCopyWith<RecurringDays> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringDaysCopyWith<$Res> {
  factory $RecurringDaysCopyWith(
    RecurringDays value,
    $Res Function(RecurringDays) then,
  ) = _$RecurringDaysCopyWithImpl<$Res, RecurringDays>;
  @useResult
  $Res call({String day, List<DayTimePeriod> periods});
}

/// @nodoc
class _$RecurringDaysCopyWithImpl<$Res, $Val extends RecurringDays>
    implements $RecurringDaysCopyWith<$Res> {
  _$RecurringDaysCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringDays
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? day = null, Object? periods = null}) {
    return _then(
      _value.copyWith(
            day:
                null == day
                    ? _value.day
                    : day // ignore: cast_nullable_to_non_nullable
                        as String,
            periods:
                null == periods
                    ? _value.periods
                    : periods // ignore: cast_nullable_to_non_nullable
                        as List<DayTimePeriod>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurringDaysImplCopyWith<$Res>
    implements $RecurringDaysCopyWith<$Res> {
  factory _$$RecurringDaysImplCopyWith(
    _$RecurringDaysImpl value,
    $Res Function(_$RecurringDaysImpl) then,
  ) = __$$RecurringDaysImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String day, List<DayTimePeriod> periods});
}

/// @nodoc
class __$$RecurringDaysImplCopyWithImpl<$Res>
    extends _$RecurringDaysCopyWithImpl<$Res, _$RecurringDaysImpl>
    implements _$$RecurringDaysImplCopyWith<$Res> {
  __$$RecurringDaysImplCopyWithImpl(
    _$RecurringDaysImpl _value,
    $Res Function(_$RecurringDaysImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurringDays
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? day = null, Object? periods = null}) {
    return _then(
      _$RecurringDaysImpl(
        day:
            null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                    as String,
        periods:
            null == periods
                ? _value._periods
                : periods // ignore: cast_nullable_to_non_nullable
                    as List<DayTimePeriod>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RecurringDaysImpl implements _RecurringDays {
  const _$RecurringDaysImpl({
    required this.day,
    required final List<DayTimePeriod> periods,
  }) : _periods = periods;

  factory _$RecurringDaysImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringDaysImplFromJson(json);

  @override
  final String day;
  // backend uses string day key
  final List<DayTimePeriod> _periods;
  // backend uses string day key
  @override
  List<DayTimePeriod> get periods {
    if (_periods is EqualUnmodifiableListView) return _periods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_periods);
  }

  @override
  String toString() {
    return 'RecurringDays(day: $day, periods: $periods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringDaysImpl &&
            (identical(other.day, day) || other.day == day) &&
            const DeepCollectionEquality().equals(other._periods, _periods));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    day,
    const DeepCollectionEquality().hash(_periods),
  );

  /// Create a copy of RecurringDays
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringDaysImplCopyWith<_$RecurringDaysImpl> get copyWith =>
      __$$RecurringDaysImplCopyWithImpl<_$RecurringDaysImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringDaysImplToJson(this);
  }
}

abstract class _RecurringDays implements RecurringDays {
  const factory _RecurringDays({
    required final String day,
    required final List<DayTimePeriod> periods,
  }) = _$RecurringDaysImpl;

  factory _RecurringDays.fromJson(Map<String, dynamic> json) =
      _$RecurringDaysImpl.fromJson;

  @override
  String get day; // backend uses string day key
  @override
  List<DayTimePeriod> get periods;

  /// Create a copy of RecurringDays
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringDaysImplCopyWith<_$RecurringDaysImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurringAdvertDetails _$RecurringAdvertDetailsFromJson(
  Map<String, dynamic> json,
) {
  return _RecurringAdvertDetails.fromJson(json);
}

/// @nodoc
mixin _$RecurringAdvertDetails {
  RecurrenceType get recurrence => throw _privateConstructorUsedError;
  TimeCommitment get timeCommitmentPerSession =>
      throw _privateConstructorUsedError;
  DurationType get duration => throw _privateConstructorUsedError;
  List<RecurringDays> get specificDays => throw _privateConstructorUsedError;

  /// Serializes this RecurringAdvertDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringAdvertDetailsCopyWith<RecurringAdvertDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringAdvertDetailsCopyWith<$Res> {
  factory $RecurringAdvertDetailsCopyWith(
    RecurringAdvertDetails value,
    $Res Function(RecurringAdvertDetails) then,
  ) = _$RecurringAdvertDetailsCopyWithImpl<$Res, RecurringAdvertDetails>;
  @useResult
  $Res call({
    RecurrenceType recurrence,
    TimeCommitment timeCommitmentPerSession,
    DurationType duration,
    List<RecurringDays> specificDays,
  });
}

/// @nodoc
class _$RecurringAdvertDetailsCopyWithImpl<
  $Res,
  $Val extends RecurringAdvertDetails
>
    implements $RecurringAdvertDetailsCopyWith<$Res> {
  _$RecurringAdvertDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurrence = null,
    Object? timeCommitmentPerSession = null,
    Object? duration = null,
    Object? specificDays = null,
  }) {
    return _then(
      _value.copyWith(
            recurrence:
                null == recurrence
                    ? _value.recurrence
                    : recurrence // ignore: cast_nullable_to_non_nullable
                        as RecurrenceType,
            timeCommitmentPerSession:
                null == timeCommitmentPerSession
                    ? _value.timeCommitmentPerSession
                    : timeCommitmentPerSession // ignore: cast_nullable_to_non_nullable
                        as TimeCommitment,
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as DurationType,
            specificDays:
                null == specificDays
                    ? _value.specificDays
                    : specificDays // ignore: cast_nullable_to_non_nullable
                        as List<RecurringDays>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurringAdvertDetailsImplCopyWith<$Res>
    implements $RecurringAdvertDetailsCopyWith<$Res> {
  factory _$$RecurringAdvertDetailsImplCopyWith(
    _$RecurringAdvertDetailsImpl value,
    $Res Function(_$RecurringAdvertDetailsImpl) then,
  ) = __$$RecurringAdvertDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RecurrenceType recurrence,
    TimeCommitment timeCommitmentPerSession,
    DurationType duration,
    List<RecurringDays> specificDays,
  });
}

/// @nodoc
class __$$RecurringAdvertDetailsImplCopyWithImpl<$Res>
    extends
        _$RecurringAdvertDetailsCopyWithImpl<$Res, _$RecurringAdvertDetailsImpl>
    implements _$$RecurringAdvertDetailsImplCopyWith<$Res> {
  __$$RecurringAdvertDetailsImplCopyWithImpl(
    _$RecurringAdvertDetailsImpl _value,
    $Res Function(_$RecurringAdvertDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurringAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurrence = null,
    Object? timeCommitmentPerSession = null,
    Object? duration = null,
    Object? specificDays = null,
  }) {
    return _then(
      _$RecurringAdvertDetailsImpl(
        recurrence:
            null == recurrence
                ? _value.recurrence
                : recurrence // ignore: cast_nullable_to_non_nullable
                    as RecurrenceType,
        timeCommitmentPerSession:
            null == timeCommitmentPerSession
                ? _value.timeCommitmentPerSession
                : timeCommitmentPerSession // ignore: cast_nullable_to_non_nullable
                    as TimeCommitment,
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as DurationType,
        specificDays:
            null == specificDays
                ? _value._specificDays
                : specificDays // ignore: cast_nullable_to_non_nullable
                    as List<RecurringDays>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RecurringAdvertDetailsImpl implements _RecurringAdvertDetails {
  const _$RecurringAdvertDetailsImpl({
    required this.recurrence,
    required this.timeCommitmentPerSession,
    required this.duration,
    required final List<RecurringDays> specificDays,
  }) : _specificDays = specificDays;

  factory _$RecurringAdvertDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringAdvertDetailsImplFromJson(json);

  @override
  final RecurrenceType recurrence;
  @override
  final TimeCommitment timeCommitmentPerSession;
  @override
  final DurationType duration;
  final List<RecurringDays> _specificDays;
  @override
  List<RecurringDays> get specificDays {
    if (_specificDays is EqualUnmodifiableListView) return _specificDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specificDays);
  }

  @override
  String toString() {
    return 'RecurringAdvertDetails(recurrence: $recurrence, timeCommitmentPerSession: $timeCommitmentPerSession, duration: $duration, specificDays: $specificDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringAdvertDetailsImpl &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(
                  other.timeCommitmentPerSession,
                  timeCommitmentPerSession,
                ) ||
                other.timeCommitmentPerSession == timeCommitmentPerSession) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(
              other._specificDays,
              _specificDays,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    recurrence,
    timeCommitmentPerSession,
    duration,
    const DeepCollectionEquality().hash(_specificDays),
  );

  /// Create a copy of RecurringAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringAdvertDetailsImplCopyWith<_$RecurringAdvertDetailsImpl>
  get copyWith =>
      __$$RecurringAdvertDetailsImplCopyWithImpl<_$RecurringAdvertDetailsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringAdvertDetailsImplToJson(this);
  }
}

abstract class _RecurringAdvertDetails implements RecurringAdvertDetails {
  const factory _RecurringAdvertDetails({
    required final RecurrenceType recurrence,
    required final TimeCommitment timeCommitmentPerSession,
    required final DurationType duration,
    required final List<RecurringDays> specificDays,
  }) = _$RecurringAdvertDetailsImpl;

  factory _RecurringAdvertDetails.fromJson(Map<String, dynamic> json) =
      _$RecurringAdvertDetailsImpl.fromJson;

  @override
  RecurrenceType get recurrence;
  @override
  TimeCommitment get timeCommitmentPerSession;
  @override
  DurationType get duration;
  @override
  List<RecurringDays> get specificDays;

  /// Create a copy of RecurringAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringAdvertDetailsImplCopyWith<_$RecurringAdvertDetailsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OneOffAdvertDetails _$OneOffAdvertDetailsFromJson(Map<String, dynamic> json) {
  return _OneOffAdvertDetails.fromJson(json);
}

/// @nodoc
mixin _$OneOffAdvertDetails {
  DateTime get eventDatetime => throw _privateConstructorUsedError;
  TimeCommitment get timeCommitment => throw _privateConstructorUsedError;
  DateTime get applicationDeadline => throw _privateConstructorUsedError;

  /// Serializes this OneOffAdvertDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OneOffAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OneOffAdvertDetailsCopyWith<OneOffAdvertDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OneOffAdvertDetailsCopyWith<$Res> {
  factory $OneOffAdvertDetailsCopyWith(
    OneOffAdvertDetails value,
    $Res Function(OneOffAdvertDetails) then,
  ) = _$OneOffAdvertDetailsCopyWithImpl<$Res, OneOffAdvertDetails>;
  @useResult
  $Res call({
    DateTime eventDatetime,
    TimeCommitment timeCommitment,
    DateTime applicationDeadline,
  });
}

/// @nodoc
class _$OneOffAdvertDetailsCopyWithImpl<$Res, $Val extends OneOffAdvertDetails>
    implements $OneOffAdvertDetailsCopyWith<$Res> {
  _$OneOffAdvertDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OneOffAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventDatetime = null,
    Object? timeCommitment = null,
    Object? applicationDeadline = null,
  }) {
    return _then(
      _value.copyWith(
            eventDatetime:
                null == eventDatetime
                    ? _value.eventDatetime
                    : eventDatetime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            timeCommitment:
                null == timeCommitment
                    ? _value.timeCommitment
                    : timeCommitment // ignore: cast_nullable_to_non_nullable
                        as TimeCommitment,
            applicationDeadline:
                null == applicationDeadline
                    ? _value.applicationDeadline
                    : applicationDeadline // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OneOffAdvertDetailsImplCopyWith<$Res>
    implements $OneOffAdvertDetailsCopyWith<$Res> {
  factory _$$OneOffAdvertDetailsImplCopyWith(
    _$OneOffAdvertDetailsImpl value,
    $Res Function(_$OneOffAdvertDetailsImpl) then,
  ) = __$$OneOffAdvertDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime eventDatetime,
    TimeCommitment timeCommitment,
    DateTime applicationDeadline,
  });
}

/// @nodoc
class __$$OneOffAdvertDetailsImplCopyWithImpl<$Res>
    extends _$OneOffAdvertDetailsCopyWithImpl<$Res, _$OneOffAdvertDetailsImpl>
    implements _$$OneOffAdvertDetailsImplCopyWith<$Res> {
  __$$OneOffAdvertDetailsImplCopyWithImpl(
    _$OneOffAdvertDetailsImpl _value,
    $Res Function(_$OneOffAdvertDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OneOffAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventDatetime = null,
    Object? timeCommitment = null,
    Object? applicationDeadline = null,
  }) {
    return _then(
      _$OneOffAdvertDetailsImpl(
        eventDatetime:
            null == eventDatetime
                ? _value.eventDatetime
                : eventDatetime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        timeCommitment:
            null == timeCommitment
                ? _value.timeCommitment
                : timeCommitment // ignore: cast_nullable_to_non_nullable
                    as TimeCommitment,
        applicationDeadline:
            null == applicationDeadline
                ? _value.applicationDeadline
                : applicationDeadline // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$OneOffAdvertDetailsImpl implements _OneOffAdvertDetails {
  const _$OneOffAdvertDetailsImpl({
    required this.eventDatetime,
    required this.timeCommitment,
    required this.applicationDeadline,
  });

  factory _$OneOffAdvertDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OneOffAdvertDetailsImplFromJson(json);

  @override
  final DateTime eventDatetime;
  @override
  final TimeCommitment timeCommitment;
  @override
  final DateTime applicationDeadline;

  @override
  String toString() {
    return 'OneOffAdvertDetails(eventDatetime: $eventDatetime, timeCommitment: $timeCommitment, applicationDeadline: $applicationDeadline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OneOffAdvertDetailsImpl &&
            (identical(other.eventDatetime, eventDatetime) ||
                other.eventDatetime == eventDatetime) &&
            (identical(other.timeCommitment, timeCommitment) ||
                other.timeCommitment == timeCommitment) &&
            (identical(other.applicationDeadline, applicationDeadline) ||
                other.applicationDeadline == applicationDeadline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    eventDatetime,
    timeCommitment,
    applicationDeadline,
  );

  /// Create a copy of OneOffAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OneOffAdvertDetailsImplCopyWith<_$OneOffAdvertDetailsImpl> get copyWith =>
      __$$OneOffAdvertDetailsImplCopyWithImpl<_$OneOffAdvertDetailsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OneOffAdvertDetailsImplToJson(this);
  }
}

abstract class _OneOffAdvertDetails implements OneOffAdvertDetails {
  const factory _OneOffAdvertDetails({
    required final DateTime eventDatetime,
    required final TimeCommitment timeCommitment,
    required final DateTime applicationDeadline,
  }) = _$OneOffAdvertDetailsImpl;

  factory _OneOffAdvertDetails.fromJson(Map<String, dynamic> json) =
      _$OneOffAdvertDetailsImpl.fromJson;

  @override
  DateTime get eventDatetime;
  @override
  TimeCommitment get timeCommitment;
  @override
  DateTime get applicationDeadline;

  /// Create a copy of OneOffAdvertDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OneOffAdvertDetailsImplCopyWith<_$OneOffAdvertDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Advert _$AdvertFromJson(Map<String, dynamic> json) {
  return _Advert.fromJson(json);
}

/// @nodoc
mixin _$Advert {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  FrequencyType get frequency => throw _privateConstructorUsedError;
  int get numberOfVolunteers => throw _privateConstructorUsedError;
  LocationType get locationType => throw _privateConstructorUsedError;
  String? get addressText => throw _privateConstructorUsedError;
  String? get postcode => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get advertImageUrl => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  OrganizerProfile get organizer => throw _privateConstructorUsedError;
  List<Skill> get requiredSkills => throw _privateConstructorUsedError;
  OneOffAdvertDetails? get oneoffDetails => throw _privateConstructorUsedError;
  RecurringAdvertDetails? get recurringDetails =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Advert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdvertCopyWith<Advert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdvertCopyWith<$Res> {
  factory $AdvertCopyWith(Advert value, $Res Function(Advert) then) =
      _$AdvertCopyWithImpl<$Res, Advert>;
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    String category,
    FrequencyType frequency,
    int numberOfVolunteers,
    LocationType locationType,
    String? addressText,
    String? postcode,
    double? latitude,
    double? longitude,
    String? advertImageUrl,
    bool isActive,
    OrganizerProfile organizer,
    List<Skill> requiredSkills,
    OneOffAdvertDetails? oneoffDetails,
    RecurringAdvertDetails? recurringDetails,
    DateTime createdAt,
  });

  $OrganizerProfileCopyWith<$Res> get organizer;
  $OneOffAdvertDetailsCopyWith<$Res>? get oneoffDetails;
  $RecurringAdvertDetailsCopyWith<$Res>? get recurringDetails;
}

/// @nodoc
class _$AdvertCopyWithImpl<$Res, $Val extends Advert>
    implements $AdvertCopyWith<$Res> {
  _$AdvertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? frequency = null,
    Object? numberOfVolunteers = null,
    Object? locationType = null,
    Object? addressText = freezed,
    Object? postcode = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? advertImageUrl = freezed,
    Object? isActive = null,
    Object? organizer = null,
    Object? requiredSkills = null,
    Object? oneoffDetails = freezed,
    Object? recurringDetails = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            category:
                null == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String,
            frequency:
                null == frequency
                    ? _value.frequency
                    : frequency // ignore: cast_nullable_to_non_nullable
                        as FrequencyType,
            numberOfVolunteers:
                null == numberOfVolunteers
                    ? _value.numberOfVolunteers
                    : numberOfVolunteers // ignore: cast_nullable_to_non_nullable
                        as int,
            locationType:
                null == locationType
                    ? _value.locationType
                    : locationType // ignore: cast_nullable_to_non_nullable
                        as LocationType,
            addressText:
                freezed == addressText
                    ? _value.addressText
                    : addressText // ignore: cast_nullable_to_non_nullable
                        as String?,
            postcode:
                freezed == postcode
                    ? _value.postcode
                    : postcode // ignore: cast_nullable_to_non_nullable
                        as String?,
            latitude:
                freezed == latitude
                    ? _value.latitude
                    : latitude // ignore: cast_nullable_to_non_nullable
                        as double?,
            longitude:
                freezed == longitude
                    ? _value.longitude
                    : longitude // ignore: cast_nullable_to_non_nullable
                        as double?,
            advertImageUrl:
                freezed == advertImageUrl
                    ? _value.advertImageUrl
                    : advertImageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            organizer:
                null == organizer
                    ? _value.organizer
                    : organizer // ignore: cast_nullable_to_non_nullable
                        as OrganizerProfile,
            requiredSkills:
                null == requiredSkills
                    ? _value.requiredSkills
                    : requiredSkills // ignore: cast_nullable_to_non_nullable
                        as List<Skill>,
            oneoffDetails:
                freezed == oneoffDetails
                    ? _value.oneoffDetails
                    : oneoffDetails // ignore: cast_nullable_to_non_nullable
                        as OneOffAdvertDetails?,
            recurringDetails:
                freezed == recurringDetails
                    ? _value.recurringDetails
                    : recurringDetails // ignore: cast_nullable_to_non_nullable
                        as RecurringAdvertDetails?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizerProfileCopyWith<$Res> get organizer {
    return $OrganizerProfileCopyWith<$Res>(_value.organizer, (value) {
      return _then(_value.copyWith(organizer: value) as $Val);
    });
  }

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OneOffAdvertDetailsCopyWith<$Res>? get oneoffDetails {
    if (_value.oneoffDetails == null) {
      return null;
    }

    return $OneOffAdvertDetailsCopyWith<$Res>(_value.oneoffDetails!, (value) {
      return _then(_value.copyWith(oneoffDetails: value) as $Val);
    });
  }

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurringAdvertDetailsCopyWith<$Res>? get recurringDetails {
    if (_value.recurringDetails == null) {
      return null;
    }

    return $RecurringAdvertDetailsCopyWith<$Res>(_value.recurringDetails!, (
      value,
    ) {
      return _then(_value.copyWith(recurringDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdvertImplCopyWith<$Res> implements $AdvertCopyWith<$Res> {
  factory _$$AdvertImplCopyWith(
    _$AdvertImpl value,
    $Res Function(_$AdvertImpl) then,
  ) = __$$AdvertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    String category,
    FrequencyType frequency,
    int numberOfVolunteers,
    LocationType locationType,
    String? addressText,
    String? postcode,
    double? latitude,
    double? longitude,
    String? advertImageUrl,
    bool isActive,
    OrganizerProfile organizer,
    List<Skill> requiredSkills,
    OneOffAdvertDetails? oneoffDetails,
    RecurringAdvertDetails? recurringDetails,
    DateTime createdAt,
  });

  @override
  $OrganizerProfileCopyWith<$Res> get organizer;
  @override
  $OneOffAdvertDetailsCopyWith<$Res>? get oneoffDetails;
  @override
  $RecurringAdvertDetailsCopyWith<$Res>? get recurringDetails;
}

/// @nodoc
class __$$AdvertImplCopyWithImpl<$Res>
    extends _$AdvertCopyWithImpl<$Res, _$AdvertImpl>
    implements _$$AdvertImplCopyWith<$Res> {
  __$$AdvertImplCopyWithImpl(
    _$AdvertImpl _value,
    $Res Function(_$AdvertImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? frequency = null,
    Object? numberOfVolunteers = null,
    Object? locationType = null,
    Object? addressText = freezed,
    Object? postcode = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? advertImageUrl = freezed,
    Object? isActive = null,
    Object? organizer = null,
    Object? requiredSkills = null,
    Object? oneoffDetails = freezed,
    Object? recurringDetails = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$AdvertImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        category:
            null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String,
        frequency:
            null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                    as FrequencyType,
        numberOfVolunteers:
            null == numberOfVolunteers
                ? _value.numberOfVolunteers
                : numberOfVolunteers // ignore: cast_nullable_to_non_nullable
                    as int,
        locationType:
            null == locationType
                ? _value.locationType
                : locationType // ignore: cast_nullable_to_non_nullable
                    as LocationType,
        addressText:
            freezed == addressText
                ? _value.addressText
                : addressText // ignore: cast_nullable_to_non_nullable
                    as String?,
        postcode:
            freezed == postcode
                ? _value.postcode
                : postcode // ignore: cast_nullable_to_non_nullable
                    as String?,
        latitude:
            freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                    as double?,
        longitude:
            freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                    as double?,
        advertImageUrl:
            freezed == advertImageUrl
                ? _value.advertImageUrl
                : advertImageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        organizer:
            null == organizer
                ? _value.organizer
                : organizer // ignore: cast_nullable_to_non_nullable
                    as OrganizerProfile,
        requiredSkills:
            null == requiredSkills
                ? _value._requiredSkills
                : requiredSkills // ignore: cast_nullable_to_non_nullable
                    as List<Skill>,
        oneoffDetails:
            freezed == oneoffDetails
                ? _value.oneoffDetails
                : oneoffDetails // ignore: cast_nullable_to_non_nullable
                    as OneOffAdvertDetails?,
        recurringDetails:
            freezed == recurringDetails
                ? _value.recurringDetails
                : recurringDetails // ignore: cast_nullable_to_non_nullable
                    as RecurringAdvertDetails?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$AdvertImpl implements _Advert {
  const _$AdvertImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.numberOfVolunteers,
    required this.locationType,
    this.addressText,
    this.postcode,
    this.latitude,
    this.longitude,
    this.advertImageUrl,
    required this.isActive,
    required this.organizer,
    final List<Skill> requiredSkills = const [],
    this.oneoffDetails,
    this.recurringDetails,
    required this.createdAt,
  }) : _requiredSkills = requiredSkills;

  factory _$AdvertImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdvertImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String category;
  @override
  final FrequencyType frequency;
  @override
  final int numberOfVolunteers;
  @override
  final LocationType locationType;
  @override
  final String? addressText;
  @override
  final String? postcode;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? advertImageUrl;
  @override
  final bool isActive;
  @override
  final OrganizerProfile organizer;
  final List<Skill> _requiredSkills;
  @override
  @JsonKey()
  List<Skill> get requiredSkills {
    if (_requiredSkills is EqualUnmodifiableListView) return _requiredSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredSkills);
  }

  @override
  final OneOffAdvertDetails? oneoffDetails;
  @override
  final RecurringAdvertDetails? recurringDetails;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Advert(id: $id, title: $title, description: $description, category: $category, frequency: $frequency, numberOfVolunteers: $numberOfVolunteers, locationType: $locationType, addressText: $addressText, postcode: $postcode, latitude: $latitude, longitude: $longitude, advertImageUrl: $advertImageUrl, isActive: $isActive, organizer: $organizer, requiredSkills: $requiredSkills, oneoffDetails: $oneoffDetails, recurringDetails: $recurringDetails, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdvertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.numberOfVolunteers, numberOfVolunteers) ||
                other.numberOfVolunteers == numberOfVolunteers) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.addressText, addressText) ||
                other.addressText == addressText) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.advertImageUrl, advertImageUrl) ||
                other.advertImageUrl == advertImageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            const DeepCollectionEquality().equals(
              other._requiredSkills,
              _requiredSkills,
            ) &&
            (identical(other.oneoffDetails, oneoffDetails) ||
                other.oneoffDetails == oneoffDetails) &&
            (identical(other.recurringDetails, recurringDetails) ||
                other.recurringDetails == recurringDetails) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    category,
    frequency,
    numberOfVolunteers,
    locationType,
    addressText,
    postcode,
    latitude,
    longitude,
    advertImageUrl,
    isActive,
    organizer,
    const DeepCollectionEquality().hash(_requiredSkills),
    oneoffDetails,
    recurringDetails,
    createdAt,
  );

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdvertImplCopyWith<_$AdvertImpl> get copyWith =>
      __$$AdvertImplCopyWithImpl<_$AdvertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdvertImplToJson(this);
  }
}

abstract class _Advert implements Advert {
  const factory _Advert({
    required final int id,
    required final String title,
    required final String description,
    required final String category,
    required final FrequencyType frequency,
    required final int numberOfVolunteers,
    required final LocationType locationType,
    final String? addressText,
    final String? postcode,
    final double? latitude,
    final double? longitude,
    final String? advertImageUrl,
    required final bool isActive,
    required final OrganizerProfile organizer,
    final List<Skill> requiredSkills,
    final OneOffAdvertDetails? oneoffDetails,
    final RecurringAdvertDetails? recurringDetails,
    required final DateTime createdAt,
  }) = _$AdvertImpl;

  factory _Advert.fromJson(Map<String, dynamic> json) = _$AdvertImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get category;
  @override
  FrequencyType get frequency;
  @override
  int get numberOfVolunteers;
  @override
  LocationType get locationType;
  @override
  String? get addressText;
  @override
  String? get postcode;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get advertImageUrl;
  @override
  bool get isActive;
  @override
  OrganizerProfile get organizer;
  @override
  List<Skill> get requiredSkills;
  @override
  OneOffAdvertDetails? get oneoffDetails;
  @override
  RecurringAdvertDetails? get recurringDetails;
  @override
  DateTime get createdAt;

  /// Create a copy of Advert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdvertImplCopyWith<_$AdvertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
