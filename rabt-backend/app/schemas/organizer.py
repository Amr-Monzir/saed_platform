from pydantic import BaseModel
from typing import Optional


class OrganizerBase(BaseModel):
    name: str
    logo_url: Optional[str] = None
    website: Optional[str] = None
    description: Optional[str] = None


class OrganizerCreate(OrganizerBase):
    email: str
    password: str


class OrganizerUpdate(OrganizerBase):
    pass


class OrganizerResponse(OrganizerBase):
    id: int

    class Config:
        from_attributes = True
