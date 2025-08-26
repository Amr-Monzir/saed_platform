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
