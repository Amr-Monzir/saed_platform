# Local Development Setup

## Option 1: Full Production Setup (Recommended for testing)

### 1. Install PostgreSQL locally
```bash
# macOS with Homebrew
brew install postgresql
brew services start postgresql

# Create database
createdb rabt_local
```

### 2. Setup AWS S3
- Create an S3 bucket for development (or use the same as production)
- Create an IAM user with S3 access (or use your existing AWS credentials)
- Get your AWS Access Key ID and Secret Access Key

### 3. Create local .env file
```bash
cp .env.example .env
```

Edit `.env` with your local values:
```env
DATABASE_URL=postgresql://username:password@localhost:5432/rabt_local
SECRET_KEY=your-local-secret-key
AWS_ACCESS_KEY_ID=your-aws-access-key-id
AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
AWS_REGION=us-east-1
S3_BUCKET_NAME=your-dev-bucket-name
S3_CUSTOM_DOMAIN=
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173
```

### 4. Run migrations and start
```bash
# Install dependencies
uv sync

# Run migrations
alembic upgrade head

# Start the server
uvicorn app.main:app --reload
```

## Option 2: Hybrid Setup (SQLite + S3)

If you want to keep using SQLite locally but still test S3 functionality:

### 1. Create local .env file
```env
DATABASE_URL=sqlite:///./rabt_local.db
SECRET_KEY=your-local-secret-key
AWS_ACCESS_KEY_ID=your-aws-access-key-id
AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
AWS_REGION=us-east-1
S3_BUCKET_NAME=your-dev-bucket-name
S3_CUSTOM_DOMAIN=
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173
```

### 2. Update database connection for local SQLite
Create `app/database/local_connection.py`:
```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from app.config import settings
import os

# Use SQLite for local development if DATABASE_URL contains sqlite
if "sqlite" in settings.database_url:
    engine = create_engine(
        settings.database_url,
        connect_args={"check_same_thread": False},  # SQLite specific
    )
else:
    engine = create_engine(settings.database_url)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

### 3. Update main.py to use local connection
```python
# In app/main.py, change the import:
from app.database.local_connection import Base, engine
```

## Option 3: Docker Compose (Easiest)

Create `docker-compose.local.yml`:
```yaml
version: "3.8"
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: rabt_local
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@postgres:5432/rabt_local
      - SECRET_KEY=your-local-secret-key
      - AWS_ACCESS_KEY_ID=your-aws-access-key-id
      - AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
      - AWS_REGION=us-east-1
      - S3_BUCKET_NAME=your-dev-bucket-name
      - S3_CUSTOM_DOMAIN=
      - ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173
    depends_on:
      - postgres

volumes:
  postgres_data:
```

Run with:
```bash
docker-compose -f docker-compose.local.yml up
```

## Quick Start Script

Create `run_local.sh`:
```bash
#!/bin/bash

# Check if .env exists
if [ ! -f .env ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo "Please edit .env with your local configuration"
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
uv sync

# Run migrations
echo "Running migrations..."
alembic upgrade head

# Start server
echo "Starting server..."
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Make it executable and run:
```bash
chmod +x run_local.sh
./run_local.sh
```

## Testing File Uploads

With S3 configured, your file uploads will work exactly the same as before:
- Upload images via `/api/v1/upload/image`
- Upload logos via `/api/v1/organizers/upload-logo`
- Upload advert images via `/api/v1/adverts` (with image_file parameter)

All files will be stored in your S3 bucket and served via public URLs.

## Frontend Integration

Your frontend can connect to the local backend at:
- API Base URL: `http://localhost:8000`
- API Documentation: `http://localhost:8000/docs`
- Health Check: `http://localhost:8000/api/v1/stats`

Make sure your frontend's CORS configuration includes `http://localhost:8000` in the allowed origins.

## AWS Credentials Setup

### Option A: Environment Variables (Recommended for local dev)
Add to your `.env` file:
```env
AWS_ACCESS_KEY_ID=your-key-id
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
```

### Option B: AWS CLI Configuration
If you have AWS CLI installed and configured, you can use:
```bash
aws configure
```

The boto3 library will automatically use credentials from `~/.aws/credentials` if environment variables are not set.

## S3 Bucket Setup for Development

1. Create a development bucket in AWS S3
2. Configure bucket permissions:
   - Unblock public access if you want public file URLs
   - Enable ACLs for public-read access
3. (Optional) Set up a CloudFront distribution for better performance
4. Update your `.env` with the bucket name and region