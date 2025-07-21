from enum import Enum


class UserType(str, Enum):
    VOLUNTEER = "volunteer"
    ORGANIZER = "organizer"


class FrequencyType(str, Enum):
    ONE_OFF = "one-off"
    RECURRING = "recurring"


class LocationType(str, Enum):
    REMOTE = "remote"
    HYBRID = "hybrid"
    ON_SITE = "on-site"


class TimeCommitment(str, Enum):
    ONE_TO_TWO = "1-2h"
    THREE_TO_FIVE = "3-5h"
    SIX_TO_TEN = "6-10h"
    TEN_PLUS = "10+h"


class RecurrenceType(str, Enum):
    WEEKLY = "weekly"
    BI_WEEKLY = "bi-weekly"
    MONTHLY = "monthly"


class DurationType(str, Enum):
    ONE_MONTH = "1month"
    THREE_MONTHS = "3months"
    SIX_MONTHS = "6months"
    ONGOING = "ongoing"


class DayPeriod(str, Enum):
    AM = "am"
    PM = "pm"
    AFTER_5PM = "after5pm"


class ApplicationStatus(str, Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"
    REJECTED = "rejected"
    WITHDRAWN = "withdrawn"


# SQLite validation functions (since SQLite doesn't support enums)
def validate_enum_value(enum_class, value):
    """Validate that a value is a valid enum member"""
    if value not in [e.value for e in enum_class]:
        raise ValueError(f"Invalid value '{value}' for {enum_class.__name__}")
    return value
