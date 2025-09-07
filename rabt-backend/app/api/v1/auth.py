from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta

from app.database.connection import get_db
from app.database.models import User
from app.schemas.user import Token, UserResponse, RefreshRequest
from app.auth.password_utils import verify_password
from app.auth.jwt_handler import create_access_token, create_refresh_token, verify_refresh_token
from app.config import settings

router = APIRouter(prefix="/auth", tags=["authentication"])


@router.post("/login", response_model=Token)
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)
):
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User account is deactivated",
        )

    access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    refresh_token = create_refresh_token(data={"sub": user.email})
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "expires_in": int(access_token_expires.total_seconds()),
        "token_type": "bearer",
    }


@router.post("/refresh", response_model=Token)
async def refresh_token_endpoint(body: RefreshRequest):
    email = verify_refresh_token(body.refresh_token)
    if email is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token",
        )

    access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
    new_access_token = create_access_token(
        data={"sub": email}, expires_delta=access_token_expires
    )
    new_refresh_token = create_refresh_token(data={"sub": email})

    return {
        "access_token": new_access_token,
        "refresh_token": new_refresh_token,
        "expires_in": int(access_token_expires.total_seconds()),
        "token_type": "bearer",
    }
