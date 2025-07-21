.PHONY: help install run migrate makemigrations test

help:
	@echo "Commands:"
	@echo "  install        : Install dependencies"
	@echo "  run            : Run the development server"
	@echo "  migrate        : Apply database migrations"
	@echo "  makemigrations : Create a new database migration"
	@echo "  test           : Run tests"

install:
	uv pip install -r requirements.txt

run:
	uv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

migrate:
	uv run alembic upgrade head

makemigrations:
	uv run alembic revision --autogenerate -m "$(m)"

test:
	uv run pytest
