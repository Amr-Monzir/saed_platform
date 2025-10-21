import 'package:json_annotation/json_annotation.dart';

part 'enums.g.dart';

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum UserType {
  @JsonValue('volunteer')
  volunteer,
  @JsonValue('organizer')
  organizer;

  String get displayName => switch (this) {
    UserType.volunteer => 'Volunteer',
    UserType.organizer => 'Organizer',
  };
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum FrequencyType {
  @JsonValue('one-off')
  oneOff,
  @JsonValue('recurring')
  recurring;

  String get displayName => switch (this) {
    FrequencyType.oneOff => 'One-off',
    FrequencyType.recurring => 'Recurring',
  };
  String get wireValue => switch (this) {
    FrequencyType.oneOff => 'one-off',
    FrequencyType.recurring => 'recurring',
  };
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum LocationType {
  @JsonValue('remote')
  remote,
  @JsonValue('hybrid')
  hybrid,
  @JsonValue('on-site')
  onSite;

  String get displayName => switch (this) {
    LocationType.remote => 'Remote',
    LocationType.hybrid => 'Hybrid',
    LocationType.onSite => 'On-site',
  };

  String get wireValue => switch (this) {
    LocationType.remote => 'remote',
    LocationType.hybrid => 'hybrid',
    LocationType.onSite => 'on-site',
  };
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum TimeCommitment {
  @JsonValue('1-2h')
  oneToTwo,
  @JsonValue('3-5h')
  threeToFive,
  @JsonValue('6-10h')
  sixToTen,
  @JsonValue('10+h')
  tenPlus;

  String get displayName => switch (this) {
    TimeCommitment.oneToTwo => '1-2h',
    TimeCommitment.threeToFive => '3-5h',
    TimeCommitment.sixToTen => '6-10h',
    TimeCommitment.tenPlus => '10+h',
  };
  String get wireValue => switch (this) {
    TimeCommitment.oneToTwo => '1-2h',
    TimeCommitment.threeToFive => '3-5h',
    TimeCommitment.sixToTen => '6-10h',
    TimeCommitment.tenPlus => '10+h',
  };
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum RecurrenceType {
  @JsonValue('weekly')
  weekly,
  @JsonValue('bi-weekly')
  biWeekly,
  @JsonValue('monthly')
  monthly;

  String get displayName => switch (this) {
    RecurrenceType.weekly => 'Weekly',
    RecurrenceType.biWeekly => 'Bi-weekly',
    RecurrenceType.monthly => 'Monthly',
  };
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum DurationType {
  @JsonValue('1month')
  oneMonth,
  @JsonValue('3months')
  threeMonths,
  @JsonValue('6months')
  sixMonths,
  @JsonValue('ongoing')
  ongoing;

  String get displayName => switch (this) {
    DurationType.oneMonth => '1 month',
    DurationType.threeMonths => '3 months',
    DurationType.sixMonths => '6 months',
    DurationType.ongoing => 'Ongoing',
  };
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum DayTimePeriod {
  @JsonValue('am')
  am,
  @JsonValue('pm')
  pm,
  @JsonValue('after5pm')
  after5pm;

  String get displayName => switch (this) {
    DayTimePeriod.am => 'AM',
    DayTimePeriod.pm => 'PM',
    DayTimePeriod.after5pm => 'After 5pm',
  };

  String get wireValue => switch (this) {
    DayTimePeriod.am => 'am',
    DayTimePeriod.pm => 'pm',
    DayTimePeriod.after5pm => 'after5pm',
  };
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum ApplicationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('withdrawn')
  withdrawn;

  String get displayName => switch (this) {
    ApplicationStatus.pending => 'Pending',
    ApplicationStatus.accepted => 'Accepted',
    ApplicationStatus.rejected => 'Rejected',
    ApplicationStatus.withdrawn => 'Withdrawn',
  };
}
