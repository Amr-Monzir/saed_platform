from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1 import (
    auth,
    utils,
    skills,
    volunteers,
    organizers,
    adverts,
    applications,
)
from app.database.connection import Base, engine
from app.config import settings

Base.metadata.create_all(bind=engine)

app = FastAPI()

# CORS Middleware
# When allow_credentials=True, you cannot use allow_origins=["*"]
# So we need to handle this case specially
if settings.allowed_origins == "*":
    cors_origins = ["*"]
    allow_credentials = False
else:
    cors_origins = [origin.strip() for origin in settings.allowed_origins.split(",")]
    allow_credentials = True

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=allow_credentials,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

app.include_router(auth.router, prefix="/api/v1")
app.include_router(utils.router, prefix="/api/v1")
app.include_router(skills.router, prefix="/api/v1")
app.include_router(volunteers.router, prefix="/api/v1")
app.include_router(organizers.router, prefix="/api/v1")
app.include_router(adverts.router, prefix="/api/v1")
app.include_router(applications.router, prefix="/api/v1")
