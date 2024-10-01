#!/bin/bash

AWS_REGION="eu-central-1"
AWS_ACCOUNT_ID="992382772775"
FRONTEND_IMAGE="annasever/class_schedule-frontend"
BACKEND_IMAGE="annasever/class_schedule-backend"
FRONTEND_REPO_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/class_schedule-frontend"
BACKEND_REPO_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/class_schedule-backend"

# Authenticate Docker to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $FRONTEND_REPO_URI

# Check if frontend image exists
if [[ -z "$(docker images -q $FRONTEND_IMAGE:latest 2> /dev/null)" ]]; then
    echo "Frontend image does not exist."
    exit 1
fi

# Check if backend image exists
if [[ -z "$(docker images -q $BACKEND_IMAGE:latest 2> /dev/null)" ]]; then
    echo "Backend image does not exist."
    exit 1
fi

# Tag and push frontend image
if ! docker tag $FRONTEND_IMAGE $FRONTEND_REPO_URI:latest; then
    echo "Failed to tag frontend image."
    exit 1
fi

if ! docker push $FRONTEND_REPO_URI:latest; then
    echo "Failed to push frontend image."
    exit 1
fi

# Tag and push backend image
if ! docker tag $BACKEND_IMAGE $BACKEND_REPO_URI:latest; then
    echo "Failed to tag backend image."
    exit 1
fi

if ! docker push $BACKEND_REPO_URI:latest; then
    echo "Failed to push backend image."
    exit 1
fi

echo "Images pushed successfully."
