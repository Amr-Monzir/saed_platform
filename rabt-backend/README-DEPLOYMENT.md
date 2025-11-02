# Railway Deployment Guide

This guide walks you through deploying the RABT backend to Railway with PostgreSQL and AWS S3 for file storage.

## Prerequisites

1. Railway account (sign up at [railway.app](https://railway.app))
2. AWS account with S3 access
3. Git repository with your code

## Step 1: Setup AWS S3

1. **Create S3 Bucket:**
   - Go to AWS Console → S3
   - Click "Create bucket"
   - Choose a unique bucket name (e.g., `rabt-backend-files`)
   - Select your preferred region (e.g., `us-east-1`)
   - **Recommended:** Keep "Block all public access" **enabled** for security (AWS best practice)
   - **ACL settings:** Leave ACLs disabled (recommended). AWS recommends using bucket policies instead of ACLs for access control.
   - Click "Create bucket"

2. **Choose Your Access Strategy:**

   **Option A: CloudFront Distribution (Recommended - More Secure)**
   
   AWS recommends keeping your bucket private and using CloudFront for public access:
   - Keep "Block all public access" **enabled** on the bucket
   - Create a CloudFront distribution pointing to your S3 bucket
   - Set `S3_CUSTOM_DOMAIN` to your CloudFront distribution URL
   - This provides better security, CDN performance, and custom domain support
   - See Step 5 below for CloudFront setup details

   **Option B: Public S3 Bucket (Simpler but Less Secure)**
   
   If you prefer direct S3 access:
   - Go to bucket → Permissions → Block public access
   - Edit and **uncheck "Block all public access"** (acknowledge the warning)
   - Add the following bucket policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
```

   **Note:** AWS recommends Option A for production environments.

3. **Configure CORS (if uploading from browser):**
   - Go to Permissions → CORS configuration
   - Add your frontend domain:

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST", "DELETE"],
    "AllowedOrigins": ["https://your-frontend-domain.com"],
    "ExposeHeaders": []
  }
]
```

4. **Create IAM User for Application:**
   - Go to AWS Console → IAM → Users
   - Click "Create user"
   - Choose a username (e.g., `rabt-backend-s3-user`)
   - Select "Programmatic access"
   - Attach policy: `AmazonS3FullAccess` (or create a custom policy with `s3:PutObject` and `s3:GetObject` permissions)
   - **Important:** Save the Access Key ID and Secret Access Key - you won't be able to see the secret key again!
   - **Note:** No ACL permissions needed - we use bucket policies for access control instead

5. **Setup CloudFront Distribution (Recommended for Production):**
   
   This is the AWS-recommended approach for serving files securely:
   
   - Go to AWS Console → CloudFront
   - Click "Create distribution"
   - **Origin domain:** Select your S3 bucket from the dropdown
   - **Origin access:** Choose "Origin access control settings (recommended)"
     - Create a new OAC (Origin Access Control) if needed
   - **Viewer protocol policy:** "Redirect HTTP to HTTPS"
   - **Allowed HTTP methods:** GET, HEAD, OPTIONS
   - **Price class:** Choose based on your needs
   - Click "Create distribution"
   - After creation, copy the distribution domain name (e.g., `d1234567890.cloudfront.net`)
   - **Update S3 bucket policy** to allow CloudFront access:
     - Go back to your S3 bucket → Permissions
     - Add this bucket policy (replace `DISTRIBUTION_ARN` and `BUCKET_NAME`):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket-name/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::ACCOUNT_ID:distribution/DISTRIBUTION_ID"
        }
      }
    }
  ]
}
```

   - Set `S3_CUSTOM_DOMAIN` environment variable to: `https://d1234567890.cloudfront.net`

   **Note:** If you're not using CloudFront (Option B), leave `S3_CUSTOM_DOMAIN` empty or omit it.

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
AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
AWS_REGION=<your-aws-region>
S3_BUCKET_NAME=<your-s3-bucket-name>
S3_CUSTOM_DOMAIN=<optional-cloudfront-url>
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

**Security Note:** If using CloudFront (Option A), the bucket remains private and only CloudFront can access it. This is more secure than exposing your S3 bucket directly to the public internet.

## Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string (auto-provided by Railway) | `postgresql://user:pass@host:port/db` |
| `SECRET_KEY` | JWT signing key | `generated-secret-key` |
| `AWS_ACCESS_KEY_ID` | AWS IAM user access key | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM user secret key | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `AWS_REGION` | AWS region where S3 bucket is located | `us-east-1` |
| `S3_BUCKET_NAME` | S3 bucket name | `rabt-backend-files` |
| `S3_CUSTOM_DOMAIN` | CloudFront distribution URL (recommended) or leave empty for direct S3 URLs | `https://d1234.cloudfront.net` or empty |
| `ALLOWED_ORIGINS` | Comma-separated CORS origins | `https://yourdomain.com` |

## Troubleshooting

### Database Connection Issues
- Ensure PostgreSQL service is running in Railway
- Check that `DATABASE_URL` is properly set

### File Upload Issues
- Verify AWS credentials are correct and have S3 permissions
- Check bucket permissions and CORS settings
- Ensure bucket exists in the specified region
- Verify the IAM user has `s3:PutObject` permissions (no ACL permissions needed)
- If using CloudFront with private bucket: Ensure bucket policy allows CloudFront access
- Note: Public access is controlled via bucket policies, not ACLs (which we don't use)

### CORS Issues
- Update `ALLOWED_ORIGINS` with your frontend domain
- Configure CORS in S3 bucket settings
- Use HTTPS URLs in production

### Migration Issues
- Check Railway logs for Alembic errors
- Ensure database is accessible during build

### S3 Access Denied Errors
- Verify IAM user has correct permissions
- Check bucket policy allows public access (if needed)
- Ensure ACLs are enabled on the bucket

## API Endpoints

After deployment, your API will be available at:
- Base URL: `https://your-app.railway.app`
- Health Check: `https://your-app.railway.app/api/v1/stats`
- API Documentation: `https://your-app.railway.app/docs`

## File Storage

All uploaded files (images, logos) are now stored in AWS S3 and served via public URLs. The file organization structure is preserved:
- Advert images: `adverts/{advert_id}/{uuid}.{ext}`
- Organization logos: `logos/{organizer_id}/{uuid}.{ext}`
- General uploads: `general/{entity_id}/{uuid}.{ext}`

Files are stored with `public-read` ACL by default, making them publicly accessible via S3 URLs or CloudFront distribution if configured.