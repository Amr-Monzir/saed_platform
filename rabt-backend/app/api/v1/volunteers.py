from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.database.connection import get_db
from app.database.models import User, Volunteer
from app.schemas.volunteer import VolunteerCreate, VolunteerResponse, VolunteerUpdate
from app.services.user_service import UserService
from app.api.dependencies import require_volunteer

router = APIRouter(prefix="/volunteers", tags=["Volunteers"])


@router.post("/register", status_code=status.HTTP_201_CREATED)
def register_volunteer(volunteer_data: VolunteerCreate, db: Session = Depends(get_db)):
    user = UserService.create_volunteer(db, volunteer_data)
    return {
        "message": "Volunteer registered successfully",
        "user_id": user.id,
        "onboarding_required": True,
    }


@router.get("/profile", response_model=VolunteerResponse)
def get_volunteer_profile(current_user: User = Depends(require_volunteer)):
    volunteer = current_user.volunteer
    volunteer.email = current_user.email
    return volunteer


@router.put("/profile", response_model=VolunteerResponse)
def update_volunteer_profile(
    profile_data: VolunteerUpdate,
    current_user: User = Depends(require_volunteer),
    db: Session = Depends(get_db),
):
    volunteer = current_user.volunteer

    # Update basic fields
    update_data = profile_data.dict(exclude_unset=True)
    for key, value in update_data.items():
        if key != "skill_ids":
            setattr(volunteer, key, value)

    # Update skills
    if profile_data.skill_ids is not None:
        from app.database.models import Skill

        skills = db.query(Skill).filter(Skill.id.in_(profile_data.skill_ids)).all()
        volunteer.skills = skills

    db.commit()
    db.refresh(volunteer)
    return volunteer


@router.post("/complete-onboarding", status_code=status.HTTP_200_OK)
def complete_onboarding(
    current_user: User = Depends(require_volunteer), db: Session = Depends(get_db)
):
    volunteer = current_user.volunteer
    if volunteer.onboarding_completed:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Onboarding already completed",
        )

    volunteer.onboarding_completed = True
    db.commit()
    return {
        "message": "Onboarding completed successfully",
        "onboarding_completed": True,
    }
