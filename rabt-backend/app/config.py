from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    database_url: str = "sqlite:///./rabt.db"
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    refresh_token_expire_days: int = 30
    
    # AWS S3 settings
    aws_access_key_id: str
    aws_secret_access_key: str
    aws_region: str = "us-east-1"
    s3_bucket_name: str
    s3_custom_domain: str = ""  # Optional: for CloudFront or custom domain
    
    # CORS settings
    allowed_origins: str = "*"

    class Config:
        env_file = ".env"
        extra = "ignore"


settings = Settings()
