from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.database.models import Application, Advert, Volunteer
from app.schemas.application import ApplicationCreate
from typing import List, Optional


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

    @staticmethod
    def get_organizer_applications(
        db: Session, 
        organizer_id: int, 
        advert_id: Optional[int] = None,
        limit: int = 20,
        page: int = 1
    ) -> tuple[List[Application], int, int]:
        """
        Get all applications for an organizer's adverts with pagination.
        If advert_id is provided, filter by that specific advert.
        Returns: (applications, total_count, total_pages)
        """
        query = (
            db.query(Application)
            .join(Advert, Application.advert_id == Advert.id)
            .filter(Advert.organizer_id == organizer_id)
        )
        
        if advert_id is not None:
            query = query.filter(Application.advert_id == advert_id)
        
        # Get total count for pagination
        total_count = query.count()
        total_pages = (total_count + limit - 1) // limit if limit > 0 else 1
        current_page = max(page, 1)
        offset = (current_page - 1) * limit
        
        # Apply pagination
        applications = query.limit(limit).offset(offset).all()
        
        return applications, total_count, total_pages
