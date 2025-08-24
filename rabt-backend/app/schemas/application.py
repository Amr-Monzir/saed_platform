from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from app.database.enums import ApplicationStatus
from app.schemas.advert import AdvertResponse
from app.schemas.volunteer import VolunteerResponse


class ApplicationBase(BaseModel):
    advert_id: int
    cover_message: Optional[str] = None


class ApplicationCreate(ApplicationBase):
    pass


class ApplicationUpdate(BaseModel):
    status: ApplicationStatus
    organizer_message: Optional[str] = None


class ApplicationResponse(ApplicationBase):
    id: int
    status: ApplicationStatus
    applied_at: datetime
    advert: AdvertResponse
    volunteer: Optional[VolunteerResponse] = None  # Only for organizers

    class Config:
        from_attributes = True


class ApplicationListResponse(BaseModel):
    items: List[ApplicationResponse]
    total_count: int
    total_pages: int
