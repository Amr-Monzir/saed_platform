#!/bin/bash
set -e

echo "Running database migrations..."
alembic upgrade head

echo "Seeding database..."
python seed.py

echo "Starting application server..."
exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}
