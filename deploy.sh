#!/bin/bash

# Decrypt AWS credentials and export them
eval $(gpg --decrypt aws_credentials.gpg 2>/dev/null)

# Set AWS CLI configuration
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set default.region us-east-2  # Adjust the region as necessary

# Clear public folder
rm -rf public/*

# Create AWS Cloudfront invalidation to clear cache
aws cloudfront create-invalidation --distribution-id $AWS_CLOUDFRONT_DISTRIBUTION_ID --paths "/*"

# Build and minify the Hugo site
echo "Building and minifying the Hugo site..."
hugo --minify --verbose

# Build and Deploy with Hugo
echo "Building and deploying site with Hugo..."
hugo deploy --verbose

# Optional: Clear AWS CLI configuration for security
aws configure set aws_access_key_id ""
aws configure set aws_secret_access_key ""
aws configure set default.region ""

echo "Deployment complete."
