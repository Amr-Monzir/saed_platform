from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database.connection import get_db
from app.database.models import Volunteer, Organizer, Advert, Application
import datetime

router = APIRouter(tags=["Utilities"])


@router.get("/health")
def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.datetime.utcnow().isoformat(),
        "version": "1.0.0",
        "database": "connected",  # This is a static check, a real one would query the db
    }


@router.get("/stats")
def get_stats(db: Session = Depends(get_db)):
    total_volunteers = db.query(Volunteer).count()
    total_organizers = db.query(Organizer).count()
    active_adverts = db.query(Advert).filter(Advert.is_active == True).count()
    total_applications = db.query(Application).count()

    return {
        "total_volunteers": total_volunteers,
        "total_organizers": total_organizers,
        "active_adverts": active_adverts,
        "total_applications": total_applications,
    }
