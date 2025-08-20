import 'package:json_annotation/json_annotation.dart';

part 'enums.g.dart';

@JsonEnum(alwaysCreate: true)
enum UserType {
  @JsonValue('volunteer') volunteer,
  @JsonValue('organizer') organizer,
}

@JsonEnum(alwaysCreate: true)
enum FrequencyType {
  @JsonValue('one-off') oneOff,
  @JsonValue('recurring') recurring,
}

@JsonEnum(alwaysCreate: true)
enum LocationType {
  @JsonValue('remote') remote,
  @JsonValue('hybrid') hybrid,
  @JsonValue('on-site') onSite,
}

@JsonEnum(alwaysCreate: true)
enum TimeCommitment {
  @JsonValue('1-2h') oneToTwo,
  @JsonValue('3-5h') threeToFive,
  @JsonValue('6-10h') sixToTen,
  @JsonValue('10+h') tenPlus,
}

@JsonEnum(alwaysCreate: true)
enum RecurrenceType {
  @JsonValue('weekly') weekly,
  @JsonValue('bi-weekly') biWeekly,
  @JsonValue('monthly') monthly,
}

@JsonEnum(alwaysCreate: true)
enum DurationType {
  @JsonValue('1month') oneMonth,
  @JsonValue('3months') threeMonths,
  @JsonValue('6months') sixMonths,
  @JsonValue('ongoing') ongoing,
}

@JsonEnum(alwaysCreate: true)
enum DayPeriod {
  @JsonValue('am') am,
  @JsonValue('pm') pm,
  @JsonValue('after5pm') after5pm,
}

@JsonEnum(alwaysCreate: true)
enum ApplicationStatus {
  @JsonValue('pending') pending,
  @JsonValue('accepted') accepted,
  @JsonValue('rejected') rejected,
  @JsonValue('withdrawn') withdrawn,
}


