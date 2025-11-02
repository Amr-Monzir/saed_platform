# Use an official Python runtime as a parent image
FROM python:3.13-slim

# Set the working directory in the container
WORKDIR /app

# Install uv
RUN pip install uv

# Copy the dependency files
# When building from monorepo root, copy from rabt-backend subdirectory
COPY rabt-backend/pyproject.toml rabt-backend/uv.lock ./

# Install dependencies
RUN uv sync --system

# Copy the rest of the application code from rabt-backend directory
COPY rabt-backend/ .

# Run Alembic migrations
RUN alembic upgrade head

# Expose the port the app runs on
EXPOSE 8000

# Run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
