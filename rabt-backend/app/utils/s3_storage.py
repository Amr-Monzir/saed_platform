import os
import uuid
import boto3
from botocore.exceptions import ClientError
from fastapi import UploadFile, HTTPException
from app.config import settings


def upload_to_s3(file: UploadFile, category: str, entity_id: int) -> str:
    """
    Upload file to AWS S3 storage.
    
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
    
    # Create the object key (path in S3)
    object_key = f"{category}/{entity_id}/{unique_filename}"
    
    # Initialize S3 client
    s3_client = boto3.client(
        's3',
        aws_access_key_id=settings.aws_access_key_id,
        aws_secret_access_key=settings.aws_secret_access_key,
        region_name=settings.aws_region
    )
    
    try:
        # Upload file to S3
        file.file.seek(0)  # Reset file pointer
        # Note: Public access is handled via bucket policy or CloudFront, not ACLs
        s3_client.upload_fileobj(
            file.file,
            settings.s3_bucket_name,
            object_key,
            ExtraArgs={
                'ContentType': file.content_type
            }
        )
        
        # Return the relative path to be stored in the database
        return object_key
        
    except ClientError as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to upload file to S3: {str(e)}"
        )


def get_s3_public_url(object_key: str) -> str:
    """
    Get the public URL for an S3 object.
    
    Args:
        object_key: The object key/path in S3
    
    Returns:
        Full public URL for the file
    """
    if not object_key:
        return None
    
    # Ensure object_key doesn't start with /
    object_key = object_key.lstrip('/')
    
    # Construct S3 public URL
    # Format: https://{bucket-name}.s3.{region}.amazonaws.com/{object-key}
    if settings.s3_custom_domain and settings.s3_custom_domain.strip():
        # Use custom domain if configured (e.g., CloudFront or custom domain)
        custom_domain = settings.s3_custom_domain.rstrip('/')
        return f"{custom_domain}/{object_key}"
    else:
        # Use standard S3 URL
        return f"https://{settings.s3_bucket_name}.s3.{settings.aws_region}.amazonaws.com/{object_key}"


def delete_from_s3(object_key: str) -> bool:
    """
    Delete a file from S3 storage.
    
    Args:
        object_key: The object key/path in S3
    
    Returns:
        True if successful, False otherwise
    """
    if not object_key:
        return False
    
    # Initialize S3 client
    s3_client = boto3.client(
        's3',
        aws_access_key_id=settings.aws_access_key_id,
        aws_secret_access_key=settings.aws_secret_access_key,
        region_name=settings.aws_region
    )
    
    try:
        s3_client.delete_object(
            Bucket=settings.s3_bucket_name,
            Key=object_key
        )
        return True
    except ClientError:
        return False
