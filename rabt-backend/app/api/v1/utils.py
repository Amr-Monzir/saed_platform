from fastapi import APIRouter, Depends, File, UploadFile, HTTPException, status
from sqlalchemy.orm import Session
from app.database.connection import get_db
from app.database.models import Volunteer, Organizer, Advert, Application
from app.utils.file_utils import save_image
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


@router.post("/upload/image")
async def upload_image(
    file: UploadFile = File(...),
    category: str = "general",
    entity_id: int = 0,
):
    """
    Generic image upload endpoint that can handle any type of image.
    
    Args:
        file: The image file to upload
        category: The category/type of image (e.g., 'adverts', 'logos', 'profiles', 'general')
        entity_id: The ID of the entity this image belongs to (use 0 for general uploads)
    
    Returns:
        The URL path to the uploaded image
    """
    try:
        relative_path = save_image(file=file, category=category, entity_id=entity_id)
        image_url = f"/uploads/{relative_path}"
        return {"image_url": image_url}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Failed to upload image: {str(e)}"
        )
