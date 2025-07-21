from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    database_url: str = "sqlite:///./rabt.db"
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    upload_directory: str = "uploads"

    class Config:
        env_file = ".env"
        extra = "ignore"


settings = Settings()
