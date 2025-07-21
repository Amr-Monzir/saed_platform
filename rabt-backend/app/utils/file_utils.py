import os
import uuid
from fastapi import UploadFile, HTTPException
from app.config import settings

ALLOWED_IMAGE_TYPES = ["image/jpeg", "image/png", "image/gif"]


def save_image(file: UploadFile, advert_id: int) -> str:
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(status_code=400, detail="Invalid image type")

    # Create a unique filename
    ext = os.path.splitext(file.filename)[1]
    unique_filename = f"{uuid.uuid4()}{ext}"

    # Create the directory structure
    upload_dir = os.path.join(settings.upload_directory, "adverts", str(advert_id))
    os.makedirs(upload_dir, exist_ok=True)

    # Save the file
    file_path = os.path.join(upload_dir, unique_filename)
    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())

    # Return the path to be stored in the database
    return os.path.join("adverts", str(advert_id), unique_filename)
