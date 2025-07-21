from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
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
import os

Base.metadata.create_all(bind=engine)

app = FastAPI()

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Ensure the upload directory exists
os.makedirs(settings.upload_directory, exist_ok=True)

# Mount the static directory
app.mount("/uploads", StaticFiles(directory=settings.upload_directory), name="uploads")

app.include_router(auth.router, prefix="/api/v1")
app.include_router(utils.router, prefix="/api/v1")
app.include_router(skills.router, prefix="/api/v1")
app.include_router(volunteers.router, prefix="/api/v1")
app.include_router(organizers.router, prefix="/api/v1")
app.include_router(adverts.router, prefix="/api/v1")
app.include_router(applications.router, prefix="/api/v1")
