from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from typing import Optional
from app.database.connection import get_db
from app.database.models import User
from app.auth.jwt_handler import verify_token

security = HTTPBearer()
optional_security = HTTPBearer(auto_error=False)


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db),
) -> User:
    token = credentials.credentials
    email = verify_token(token)
    if email is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
        )

    user = db.query(User).filter(User.email == email).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found"
        )
    return user


async def get_current_user_optional(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(optional_security),
    db: Session = Depends(get_db),
) -> Optional[User]:
    """Get current user if authenticated, otherwise return None (for guests)"""
    if credentials is None:
        return None
    
    token = credentials.credentials
    email = verify_token(token)
    if email is None:
        return None

    user = db.query(User).filter(User.email == email).first()
    return user


def require_volunteer(current_user: User = Depends(get_current_user)):
    if current_user.user_type != "volunteer":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Volunteer access required"
        )
    return current_user


def require_organizer(current_user: User = Depends(get_current_user)):
    if current_user.user_type != "organizer":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Organizer access required"
        )
    return current_user
