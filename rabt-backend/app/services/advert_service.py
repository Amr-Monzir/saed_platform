from sqlalchemy.orm import Session
from fastapi import HTTPException, status, UploadFile
from app.database.models import Advert, OneOffAdvert, RecurringAdvert, Skill
from app.schemas.advert import AdvertCreate, AdvertUpdate
from app.utils.file_utils import save_image
from typing import Optional


class AdvertService:
    @staticmethod
    def create_advert(
        db: Session,
        advert_data: AdvertCreate,
        organizer_id: int,
        image_file: Optional[UploadFile] = None,
    ) -> Advert:
        # Basic advert object
        advert = Advert(
            organizer_id=organizer_id,
            title=advert_data.title,
            description=advert_data.description,
            category=advert_data.category,
            frequency=advert_data.frequency,
            number_of_volunteers=advert_data.number_of_volunteers,
            location_type=advert_data.location_type,
            address_text=advert_data.address_text,
            postcode=advert_data.postcode,
            latitude=advert_data.latitude,
            longitude=advert_data.longitude,
        )

        # Add skills
        if advert_data.required_skill_ids:
            skills = (
                db.query(Skill)
                .filter(Skill.id.in_(advert_data.required_skill_ids))
                .all()
            )
            advert.required_skills = skills

        db.add(advert)
        db.flush()

        # Handle image upload
        if image_file:
            image_path = save_image(file=image_file, category="adverts", entity_id=advert.id)
            advert.advert_image_url = image_path

        # Add details based on frequency
        if advert_data.frequency == "one-off" and advert_data.oneoff_details:
            details = OneOffAdvert(
                advert_id=advert.id, **advert_data.oneoff_details.dict()
            )
            db.add(details)
        elif advert_data.frequency == "recurring" and advert_data.recurring_details:
            details = RecurringAdvert(
                advert_id=advert.id, **advert_data.recurring_details.dict()
            )
            db.add(details)
        else:
            raise HTTPException(
                status_code=400, detail="Frequency details do not match advert type"
            )

        db.commit()
        db.refresh(advert)
        return advert

    @staticmethod
    def update_advert(
        db: Session,
        advert_id: int,
        advert_data: AdvertUpdate,
        organizer_id: int,
        image_file: Optional[UploadFile] = None,
    ) -> Advert:
        advert = (
            db.query(Advert)
            .filter(Advert.id == advert_id, Advert.organizer_id == organizer_id)
            .first()
        )
        if not advert:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Advert not found"
            )

        update_data = advert_data.dict(exclude_unset=True)

        for key, value in update_data.items():
            if key not in ["required_skill_ids", "oneoff_details", "recurring_details"]:
                setattr(advert, key, value)

        if advert_data.required_skill_ids is not None:
            skills = (
                db.query(Skill)
                .filter(Skill.id.in_(advert_data.required_skill_ids))
                .all()
            )
            advert.required_skills = skills

        if image_file:
            image_url = save_image(file=image_file, category="adverts", entity_id=advert.id)
            advert.advert_image_url = image_url

        # We assume frequency does not change. If it could, the logic would be more complex.
        if advert.frequency == "one-off" and advert_data.oneoff_details:
            db.query(OneOffAdvert).filter(OneOffAdvert.advert_id == advert.id).update(
                advert_data.oneoff_details.dict()
            )
        elif advert.frequency == "recurring" and advert_data.recurring_details:
            db.query(RecurringAdvert).filter(
                RecurringAdvert.advert_id == advert.id
            ).update(advert_data.recurring_details.dict())

        db.commit()
        db.refresh(advert)
        return advert
