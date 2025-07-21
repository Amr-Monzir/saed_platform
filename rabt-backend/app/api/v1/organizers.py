from fastapi import APIRouter, Depends, File, HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from app.api.dependencies import require_organizer
from app.database.connection import get_db
from app.database.models import Organizer, User
from app.schemas.organizer import OrganizerCreate, OrganizerResponse, OrganizerUpdate
from app.services.user_service import UserService

router = APIRouter(prefix="/organizers", tags=["Organizers"])


@router.post("/register", status_code=status.HTTP_201_CREATED)
def register_organizer(organizer_data: OrganizerCreate, db: Session = Depends(get_db)):
    user = UserService.create_organizer(db, organizer_data)
    return {
        "message": "Organizer registered successfully",
        "user_id": user.id,
        "verification_required": True,
    }


@router.get("/profile", response_model=OrganizerResponse)
def get_organizer_profile(current_user: User = Depends(require_organizer)):
    return current_user.organizer


@router.put("/profile", response_model=OrganizerResponse)
def update_organizer_profile(
    profile_data: OrganizerUpdate,
    current_user: User = Depends(require_organizer),
    db: Session = Depends(get_db),
):
    organizer = current_user.organizer
    update_data = profile_data.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(organizer, key, value)
    db.commit()
    db.refresh(organizer)
    return organizer


@router.post("/upload-logo")
async def upload_logo(
    file: UploadFile = File(...), current_user: User = Depends(require_organizer)
):
    # In a real app, this would upload to a CDN or file storage
    # and save the URL to the organizer's profile.
    return {
        "message": "Logo uploaded successfully",
        "logo_url": f"https://cdn.rabt.com/logos/{current_user.organizer.id}.jpg",
    }


@router.get("/{organizer_id}/public", response_model=OrganizerResponse)
def get_public_organizer_info(organizer_id: int, db: Session = Depends(get_db)):
    organizer = db.query(Organizer).filter(Organizer.id == organizer_id).first()
    if not organizer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Organizer not found"
        )
    return organizer
