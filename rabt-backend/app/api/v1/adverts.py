from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
    Query,
    File,
    UploadFile,
    Body,
)
from sqlalchemy.orm import Session
from typing import List, Optional
import json

from app.database.connection import get_db
from app.database.models import Advert, User, Skill
from app.schemas.advert import AdvertCreate, AdvertResponse, AdvertUpdate
from app.services.advert_service import AdvertService
from app.api.dependencies import require_organizer, get_current_user

router = APIRouter(prefix="/adverts", tags=["Adverts"])


@router.post("", response_model=AdvertResponse, status_code=status.HTTP_201_CREATED)
def create_advert(
    advert_data_json: str = Body(...),
    image_file: Optional[UploadFile] = File(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_organizer),
):
    try:
        advert_data_dict = json.loads(advert_data_json)
        advert_data = AdvertCreate(**advert_data_dict)
    except json.JSONDecodeError:
        raise HTTPException(
            status_code=400, detail="Invalid JSON format for advert data."
        )

    advert = AdvertService.create_advert(
        db, advert_data, current_user.organizer.id, image_file
    )
    return advert


@router.get("", response_model=List[AdvertResponse])
def list_adverts(
    db: Session = Depends(get_db),
    search: Optional[str] = None,
    category: Optional[str] = None,
    location_type: Optional[str] = None,
    skills: Optional[str] = Query(None),
    limit: int = 20,
    offset: int = 0,
):
    query = db.query(Advert).filter(Advert.is_active == True)
    if search:
        query = query.filter(
            Advert.title.contains(search) | Advert.description.contains(search)
        )
    if category:
        query = query.filter(Advert.category == category)
    if location_type:
        query = query.filter(Advert.location_type == location_type)
    if skills:
        skill_ids = [int(s_id) for s_id in skills.split(",")]
        query = query.join(Advert.required_skills).filter(Skill.id.in_(skill_ids))

    adverts = query.limit(limit).offset(offset).all()
    return adverts


@router.get("/{advert_id}", response_model=AdvertResponse)
def get_advert(advert_id: int, db: Session = Depends(get_db)):
    advert = db.query(Advert).filter(Advert.id == advert_id).first()
    if not advert or not advert.is_active:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Advert not found"
        )
    return advert


@router.put("/{advert_id}", response_model=AdvertResponse)
def update_advert(
    advert_id: int,
    advert_data_json: str = Body(...),
    image_file: Optional[UploadFile] = File(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_organizer),
):
    try:
        advert_data_dict = json.loads(advert_data_json)
        advert_data = AdvertUpdate(**advert_data_dict)
    except json.JSONDecodeError:
        raise HTTPException(
            status_code=400, detail="Invalid JSON format for advert data."
        )

    advert = AdvertService.update_advert(
        db, advert_id, advert_data, current_user.organizer.id, image_file
    )
    return advert


@router.delete("/{advert_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_advert(
    advert_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_organizer),
):
    advert = db.query(Advert).filter(Advert.id == advert_id).first()
    if not advert:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Advert not found"
        )
    if advert.organizer_id != current_user.organizer.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this advert",
        )

    advert.is_active = False
    db.commit()
    return


@router.get("/my-adverts", response_model=List[AdvertResponse])
def get_my_adverts(
    db: Session = Depends(get_db), current_user: User = Depends(require_organizer)
):
    adverts = (
        db.query(Advert).filter(Advert.organizer_id == current_user.organizer.id).all()
    )
    return adverts
