from pydantic import BaseModel, computed_field
from typing import Optional
from app.utils.file_utils import get_image_url


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

    @computed_field
    @property
    def logo_image_url(self) -> Optional[str]:
        """Convert relative logo path to full URL"""
        return get_image_url(self.logo_url)

    class Config:
        from_attributes = True
