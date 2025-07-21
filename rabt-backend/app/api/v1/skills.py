from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Dict

from app.database.connection import get_db
from app.database.models import Skill, Organizer
from app.schemas.skill import SkillResponse, SkillCreate
from app.api.dependencies import require_organizer

router = APIRouter(prefix="/skills", tags=["Skills"])


@router.get("", response_model=Dict[str, List[SkillResponse]])
def get_skills(db: Session = Depends(get_db)):
    skills = db.query(Skill).all()
    return {"skills": skills}


@router.post("", response_model=SkillResponse, status_code=status.HTTP_201_CREATED)
def create_skill(
    skill_data: SkillCreate,
    db: Session = Depends(get_db),
    current_user: Organizer = Depends(require_organizer),
):
    # Check if skill already exists
    existing_skill = db.query(Skill).filter(Skill.name == skill_data.name).first()
    if existing_skill:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Skill with this name already exists",
        )

    new_skill = Skill(
        name=skill_data.name,
        category=skill_data.category,
        is_predefined=False,
        created_by=current_user.organizer.id,
    )
    db.add(new_skill)
    db.commit()
    db.refresh(new_skill)
    return new_skill


@router.get("/categories", response_model=Dict[str, List[str]])
def get_skill_categories(db: Session = Depends(get_db)):
    # In a real app, you might have a separate table for categories
    categories = db.query(Skill.category).distinct().all()
    return {"categories": [c[0] for c in categories if c[0]]}
