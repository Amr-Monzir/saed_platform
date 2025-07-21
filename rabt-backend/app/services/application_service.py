from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.database.models import Application, Advert, Volunteer
from app.schemas.application import ApplicationCreate


class ApplicationService:
    @staticmethod
    def create_application(
        db: Session, application_data: ApplicationCreate, volunteer_id: int
    ) -> Application:
        # Check if advert exists and is active
        advert = (
            db.query(Advert)
            .filter(Advert.id == application_data.advert_id, Advert.is_active == True)
            .first()
        )
        if not advert:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Advert not found or is not active",
            )

        # Check if already applied
        existing_application = (
            db.query(Application)
            .filter(
                Application.advert_id == application_data.advert_id,
                Application.volunteer_id == volunteer_id,
            )
            .first()
        )
        if existing_application:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="You have already applied to this advert",
            )

        application = Application(
            advert_id=application_data.advert_id,
            volunteer_id=volunteer_id,
            cover_message=application_data.cover_message,
        )
        db.add(application)
        db.commit()
        db.refresh(application)
        return application
