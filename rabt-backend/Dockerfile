# Use an official Python runtime as a parent image
FROM python:3.13-slim

# Set the working directory in the container
WORKDIR /app

# Install uv
RUN pip install uv

# Copy the dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies (creates .venv)
RUN uv sync

# Copy the rest of the application code
COPY . .

# Add .venv to PATH so we can use installed commands
ENV PATH="/app/.venv/bin:$PATH"

# Run Alembic migrations
RUN alembic upgrade head

# Expose the port the app runs on
EXPOSE 8000

# Run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
