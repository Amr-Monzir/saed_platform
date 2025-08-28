from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import Optional

from app.database.connection import get_db
from app.database.enums import ApplicationStatus
from app.database.models import Application, User
from app.schemas.application import (
    ApplicationCreate,
    ApplicationResponse,
    ApplicationUpdate,
    ApplicationListResponse,
)
from app.services.application_service import ApplicationService
from app.api.dependencies import require_volunteer, require_organizer, get_current_user

router = APIRouter(prefix="/applications", tags=["Applications"])


@router.post(
    "", response_model=ApplicationResponse, status_code=status.HTTP_201_CREATED
)
def apply_for_advert(
    application_data: ApplicationCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_volunteer),
):
    application = ApplicationService.create_application(
        db, application_data, current_user.volunteer.id
    )
    return application


@router.get("/organization", response_model=ApplicationListResponse)
def get_organizer_applications(
    advert_id: Optional[int] = Query(None, description="Filter by specific advert ID"),
    limit: int = Query(20, description="Number of applications per page"),
    page: int = Query(1, description="Page number"),
    status: Optional[ApplicationStatus] = Query(
        None, description="Filter by application status"
    ),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_organizer),
):
    applications, total_count, total_pages = (
        ApplicationService.get_organizer_applications(
            db, current_user.organizer.id, advert_id, limit, status, page
        )
    )
    return ApplicationListResponse(
        items=applications, total_count=total_count, total_pages=total_pages
    )


@router.get("/{application_id}", response_model=ApplicationResponse)
def get_application(
    application_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    application = db.query(Application).filter(Application.id == application_id).first()
    if not application:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Application not found"
        )

    is_volunteer = (
        current_user.user_type == "volunteer"
        and application.volunteer_id == current_user.volunteer.id
    )
    is_organizer = (
        current_user.user_type == "organizer"
        and application.advert.organizer_id == current_user.organizer.id
    )

    if not is_volunteer and not is_organizer:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to view this application",
        )

    # Hide volunteer details from other volunteers
    if is_organizer:
        return application
    else:
        application.volunteer = None
        return application


@router.put("/{application_id}/status", response_model=ApplicationResponse)
def update_application_status(
    application_id: int,
    status_update: ApplicationUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_organizer),
):
    application = db.query(Application).filter(Application.id == application_id).first()
    if not application:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Application not found"
        )
    if application.advert.organizer_id != current_user.organizer.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this application",
        )

    application.status = status_update.status
    application.organizer_message = status_update.organizer_message
    db.commit()
    db.refresh(application)
    return application


@router.delete("/{application_id}", status_code=status.HTTP_204_NO_CONTENT)
def withdraw_application(
    application_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_volunteer),
):
    application = db.query(Application).filter(Application.id == application_id).first()
    if not application:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Application not found"
        )
    if application.volunteer_id != current_user.volunteer.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to withdraw this application",
        )

    db.delete(application)
    db.commit()
    return
