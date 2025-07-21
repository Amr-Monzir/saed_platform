from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from app.database.enums import UserType


class UserBase(BaseModel):
    email: EmailStr
    user_type: UserType


class UserCreate(UserBase):
    password: str


class UserResponse(UserBase):
    id: int
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: Optional[str] = None
