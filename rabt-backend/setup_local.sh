#!/bin/bash

# Local Development Setup Script for RABT Backend

echo "🚀 Setting up RABT Backend for local development..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env from .env.example..."
    cp .env.example .env
    echo ""
    echo "⚠️  Please edit .env with your local configuration:"
    echo "   - Set DATABASE_URL (PostgreSQL or SQLite)"
    echo "   - Set SECRET_KEY (generate with: python -c 'import secrets; print(secrets.token_urlsafe(32))')"
    echo "   - Set R2 credentials for file uploads"
    echo "   - Set ALLOWED_ORIGINS for your frontend"
    echo ""
    echo "After editing .env, run this script again."
    exit 1
fi

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ uv is not installed. Please install it first:"
    echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
uv sync

# Check if DATABASE_URL is set
if ! grep -q "DATABASE_URL=" .env || grep -q "your-" .env; then
    echo "❌ Please configure DATABASE_URL in .env file"
    echo "   For PostgreSQL: DATABASE_URL=postgresql://user:pass@localhost:5432/rabt_local"
    echo "   For SQLite: DATABASE_URL=sqlite:///./rabt_local.db"
    exit 1
fi

# Run migrations
echo "🗄️  Running database migrations..."
alembic upgrade head

# Check if SECRET_KEY is set
if ! grep -q "SECRET_KEY=" .env || grep -q "your-secret-key-here" .env; then
    echo "❌ Please set SECRET_KEY in .env file"
    echo "   Generate one with: python -c 'import secrets; print(secrets.token_urlsafe(32))'"
    exit 1
fi

echo "✅ Setup complete!"
echo ""
echo "🌐 Starting development server..."
echo "   API: http://localhost:8000"
echo "   Docs: http://localhost:8000/docs"
echo "   Health: http://localhost:8000/api/v1/stats"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

