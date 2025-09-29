import os
import uuid
from fastapi import UploadFile, HTTPException
from app.config import settings

ALLOWED_IMAGE_TYPES = ["image/jpeg", "image/jpg", "image/png", "image/gif"]


def save_image(file: UploadFile, category: str, entity_id: int) -> str:
    """
    Generic image upload function that saves images to organized directories.
    
    Args:
        file: The uploaded file
        category: The category/type of image (e.g., 'adverts', 'logos', 'profiles')
        entity_id: The ID of the entity this image belongs to
    
    Returns:
        Relative path to the saved image (e.g., 'adverts/123/uuid.jpg')
    """
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(status_code=400, detail="Invalid image type")

    # Create a unique filename
    ext = os.path.splitext(file.filename)[1]
    unique_filename = f"{uuid.uuid4()}{ext}"

    # Create the directory structure
    upload_dir = os.path.join(settings.upload_directory, category, str(entity_id))
    os.makedirs(upload_dir, exist_ok=True)

    # Save the file
    file_path = os.path.join(upload_dir, unique_filename)
    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())

    # Return the relative path to be stored in the database
    return os.path.join(category, str(entity_id), unique_filename)


def get_image_url(relative_path: str, base_url: str = "/uploads") -> str:
    """
    Convert a relative image path to a full URL.
    
    Args:
        relative_path: The relative path stored in database (e.g., "adverts/123/uuid.jpg")
        base_url: The base URL for serving static files (default: "/uploads")
    
    Returns:
        Full URL for the image (e.g., "/uploads/adverts/123/uuid.jpg")
    """
    if not relative_path:
        return None
    
    # Ensure base_url starts with / and doesn't end with /
    base_url = base_url.rstrip('/')
    if not base_url.startswith('/'):
        base_url = '/' + base_url
    
    # Ensure relative_path doesn't start with /
    relative_path = relative_path.lstrip('/')
    
    return f"{base_url}/{relative_path}"
