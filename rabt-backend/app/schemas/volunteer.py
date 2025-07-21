from pydantic import BaseModel, validator
from typing import Optional, List
from app.schemas.skill import SkillResponse


class VolunteerBase(BaseModel):
    name: str
    phone_number: Optional[str] = None
    city: Optional[str] = None
    country: Optional[str] = None


class VolunteerCreate(VolunteerBase):
    email: str
    password: str
    skill_ids: Optional[List[int]] = []


class VolunteerUpdate(VolunteerBase):
    skill_ids: Optional[List[int]] = None


class VolunteerResponse(VolunteerBase):
    id: int
    onboarding_completed: bool
    skills: List[SkillResponse] = []

    class Config:
        from_attributes = True


# Private version for organizers who receive applications
class VolunteerPrivateResponse(VolunteerResponse):
    email: str
    phone_number: str
