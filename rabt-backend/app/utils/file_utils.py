import os
import uuid
from fastapi import UploadFile, HTTPException
from app.config import settings
from app.utils.r2_storage import upload_to_r2, get_r2_public_url

ALLOWED_IMAGE_TYPES = ["image/jpeg", "image/jpg", "image/png", "image/gif"]


def save_image(file: UploadFile, category: str, entity_id: int) -> str:
    """
    Generic image upload function that saves images to R2 storage.
    
    Args:
        file: The uploaded file
        category: The category/type of image (e.g., 'adverts', 'logos', 'profiles')
        entity_id: The ID of the entity this image belongs to
    
    Returns:
        Relative path to the saved image (e.g., 'adverts/123/uuid.jpg')
    """
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(status_code=400, detail="Invalid image type")

    # Upload to R2 and return the object key
    return upload_to_r2(file=file, category=category, entity_id=entity_id)


def get_image_url(relative_path: str, base_url: str = None) -> str:
    """
    Convert a relative image path to a full URL.
    
    Args:
        relative_path: The relative path stored in database (e.g., "adverts/123/uuid.jpg")
        base_url: Ignored for R2 (kept for compatibility)
    
    Returns:
        Full URL for the image from R2
    """
    if not relative_path:
        return None
    
    return get_r2_public_url(relative_path)
