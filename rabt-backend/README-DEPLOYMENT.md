# Railway Deployment Guide

This guide walks you through deploying the RABT backend to Railway with PostgreSQL and Cloudflare R2 for file storage.

## Prerequisites

1. Railway account (sign up at [railway.app](https://railway.app))
2. Cloudflare account with R2 enabled
3. Git repository with your code

## Step 1: Setup Cloudflare R2

1. **Create R2 Bucket:**
   - Go to Cloudflare Dashboard → R2 Object Storage
   - Create a new bucket (e.g., `rabt-backend-files`)
   - Note the bucket name

2. **Configure Public Access:**
   - In your bucket settings, enable public access
   - Note the public URL format: `https://your-bucket-name.your-account-id.r2.cloudflarestorage.com`

3. **Generate API Tokens:**
   - Go to Cloudflare Dashboard → My Profile → API Tokens
   - Create a custom token with R2 permissions
   - Note the Access Key ID and Secret Access Key
   - Also note your Account ID (found in the right sidebar)

## Step 2: Setup Railway Project

1. **Create New Project:**
   - Go to Railway dashboard
   - Click "New Project" → "Deploy from GitHub repo"
   - Connect your GitHub repository

2. **Add PostgreSQL Database:**
   - In your project, click "New" → "Database" → "PostgreSQL"
   - Railway will automatically provide the `DATABASE_URL` environment variable

3. **Configure Environment Variables:**
   - Go to your service settings → Variables
   - Add the following variables:

```
SECRET_KEY=<generate-with-python-secrets>
R2_ACCOUNT_ID=<your-cloudflare-account-id>
R2_ACCESS_KEY_ID=<your-r2-access-key-id>
R2_SECRET_ACCESS_KEY=<your-r2-secret-access-key>
R2_BUCKET_NAME=<your-r2-bucket-name>
R2_PUBLIC_URL=<your-r2-public-url>
ALLOWED_ORIGINS=<your-frontend-domain>
```

## Step 3: Generate Secret Key

Run this command to generate a secure secret key:

```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

Use the output as your `SECRET_KEY` value.

## Step 4: Deploy

1. **Push to GitHub:**
   - Commit all changes to your repository
   - Push to the main branch

2. **Railway Auto-Deploy:**
   - Railway will automatically detect the Dockerfile
   - Build and deploy your application
   - Run Alembic migrations automatically

3. **Verify Deployment:**
   - Check the Railway logs for any errors
   - Test the health endpoint: `https://your-app.railway.app/api/v1/stats`

## Step 5: Configure CORS

Update the `ALLOWED_ORIGINS` environment variable with your frontend domain(s):

```
ALLOWED_ORIGINS=https://your-frontend-domain.com,https://another-domain.com
```

## Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string (auto-provided by Railway) | `postgresql://user:pass@host:port/db` |
| `SECRET_KEY` | JWT signing key | `generated-secret-key` |
| `R2_ACCOUNT_ID` | Cloudflare account ID | `abc123def456` |
| `R2_ACCESS_KEY_ID` | R2 API access key | `your-access-key` |
| `R2_SECRET_ACCESS_KEY` | R2 API secret key | `your-secret-key` |
| `R2_BUCKET_NAME` | R2 bucket name | `rabt-backend-files` |
| `R2_PUBLIC_URL` | R2 public URL | `https://bucket.account.r2.cloudflarestorage.com` |
| `ALLOWED_ORIGINS` | Comma-separated CORS origins | `https://yourdomain.com` |

## Troubleshooting

### Database Connection Issues
- Ensure PostgreSQL service is running in Railway
- Check that `DATABASE_URL` is properly set

### File Upload Issues
- Verify R2 credentials are correct
- Check bucket permissions and public access settings
- Ensure `R2_PUBLIC_URL` matches your bucket configuration

### CORS Issues
- Update `ALLOWED_ORIGINS` with your frontend domain
- Use HTTPS URLs in production

### Migration Issues
- Check Railway logs for Alembic errors
- Ensure database is accessible during build

## API Endpoints

After deployment, your API will be available at:
- Base URL: `https://your-app.railway.app`
- Health Check: `https://your-app.railway.app/api/v1/stats`
- API Documentation: `https://your-app.railway.app/docs`

## File Storage

All uploaded files (images, logos) are now stored in Cloudflare R2 and served via public URLs. The file organization structure is preserved:
- Advert images: `adverts/{advert_id}/{uuid}.{ext}`
- Organization logos: `logos/{organizer_id}/{uuid}.{ext}`
- General uploads: `general/{entity_id}/{uuid}.{ext}`
