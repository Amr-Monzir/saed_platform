import os
import uuid
import boto3
from botocore.exceptions import ClientError
from fastapi import UploadFile, HTTPException
from app.config import settings


def upload_to_r2(file: UploadFile, category: str, entity_id: int) -> str:
    """
    Upload file to Cloudflare R2 storage.
    
    Args:
        file: The uploaded file
        category: The category/type of image (e.g., 'adverts', 'logos', 'profiles')
        entity_id: The ID of the entity this image belongs to
    
    Returns:
        Relative path to the uploaded file (e.g., 'adverts/123/uuid.jpg')
    """
    # Create a unique filename
    ext = os.path.splitext(file.filename)[1]
    unique_filename = f"{uuid.uuid4()}{ext}"
    
    # Create the object key (path in R2)
    object_key = f"{category}/{entity_id}/{unique_filename}"
    
    # Initialize R2 client
    r2_client = boto3.client(
        's3',
        endpoint_url=f'https://{settings.r2_account_id}.r2.cloudflarestorage.com',
        aws_access_key_id=settings.r2_access_key_id,
        aws_secret_access_key=settings.r2_secret_access_key,
        region_name='auto'
    )
    
    try:
        # Upload file to R2
        file.file.seek(0)  # Reset file pointer
        r2_client.upload_fileobj(
            file.file,
            settings.r2_bucket_name,
            object_key,
            ExtraArgs={'ContentType': file.content_type}
        )
        
        # Return the relative path to be stored in the database
        return object_key
        
    except ClientError as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to upload file to R2: {str(e)}"
        )


def get_r2_public_url(object_key: str) -> str:
    """
    Get the public URL for an R2 object.
    
    Args:
        object_key: The object key/path in R2
    
    Returns:
        Full public URL for the file
    """
    if not object_key:
        return None
    
    # Ensure object_key doesn't start with /
    object_key = object_key.lstrip('/')
    
    # Return the full public URL
    return f"{settings.r2_public_url}/{object_key}"


def delete_from_r2(object_key: str) -> bool:
    """
    Delete a file from R2 storage.
    
    Args:
        object_key: The object key/path in R2
    
    Returns:
        True if successful, False otherwise
    """
    if not object_key:
        return False
    
    # Initialize R2 client
    r2_client = boto3.client(
        's3',
        endpoint_url=f'https://{settings.r2_account_id}.r2.cloudflarestorage.com',
        aws_access_key_id=settings.r2_access_key_id,
        aws_secret_access_key=settings.r2_secret_access_key,
        region_name='auto'
    )
    
    try:
        r2_client.delete_object(
            Bucket=settings.r2_bucket_name,
            Key=object_key
        )
        return True
    except ClientError:
        return False
