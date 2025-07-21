from pydantic import BaseModel
from typing import Optional


class SkillBase(BaseModel):
    name: str
    category: Optional[str] = None


class SkillCreate(SkillBase):
    pass


class SkillUpdate(SkillBase):
    pass


class SkillResponse(SkillBase):
    id: int
    is_predefined: bool

    class Config:
        from_attributes = True
