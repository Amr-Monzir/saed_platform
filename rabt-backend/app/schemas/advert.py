from pydantic import BaseModel, Field, computed_field
from typing import Optional, List
from datetime import datetime
from app.database.enums import (
    FrequencyType,
    LocationType,
    RecurrenceType,
    TimeCommitment,
    DurationType,
    DayPeriod,
)
from app.schemas.skill import SkillResponse
from app.schemas.organizer import OrganizerResponse
from app.utils.file_utils import get_image_url


class RecurringDays(BaseModel):
    day: str
    periods: List[DayPeriod]


class RecurringAdvertDetails(BaseModel):
    recurrence: RecurrenceType
    time_commitment_per_session: TimeCommitment
    duration: DurationType
    specific_days: List[RecurringDays]


class OneOffAdvertDetails(BaseModel):
    event_datetime: datetime
    time_commitment: TimeCommitment
    application_deadline: datetime


class AdvertBase(BaseModel):
    title: str
    description: str
    category: str
    frequency: FrequencyType
    number_of_volunteers: int = 1
    location_type: LocationType
    address_text: Optional[str] = None
    postcode: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    advert_image_url: Optional[str] = None


class AdvertCreate(AdvertBase):
    required_skill_ids: List[int] = []
    oneoff_details: Optional[OneOffAdvertDetails] = None
    recurring_details: Optional[RecurringAdvertDetails] = None


class AdvertUpdate(AdvertBase):
    required_skill_ids: Optional[List[int]] = None
    oneoff_details: Optional[OneOffAdvertDetails] = None
    recurring_details: Optional[RecurringAdvertDetails] = None


class AdvertResponse(AdvertBase):
    id: int
    is_active: bool
    organizer: OrganizerResponse
    required_skills: List[SkillResponse] = []
    oneoff_details: Optional[OneOffAdvertDetails] = None
    recurring_details: Optional[RecurringAdvertDetails] = None
    created_at: datetime

    @computed_field
    @property
    def image_url(self) -> Optional[str]:
        """Convert relative image path to full URL"""
        return get_image_url(self.advert_image_url)

    class Config:
        from_attributes = True


class AdvertResponseForApplications(AdvertBase):
    id: int
    is_active: bool
    organizer: OrganizerResponse
    required_skills: List[SkillResponse] = []
    created_at: datetime

    @computed_field
    @property
    def image_url(self) -> Optional[str]:
        """Convert relative image path to full URL"""
        return get_image_url(self.advert_image_url)

    class Config:
        from_attributes = True


class AdvertListResponse(BaseModel):
    items: List[AdvertResponse]
    total_pages: int

class OrganizerAdvertsListResponse(BaseModel):
    items: List[AdvertResponse]
