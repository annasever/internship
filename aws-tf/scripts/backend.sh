#!/bin/bash

REPO_URL="https://<annasever>:$TOKEN@github.com/annasever/internship_project.git"
PROJECT_DIR="/home/ubuntu/internship_project"
DOCKERFILE_PATH="$PROJECT_DIR"

if [ -d "$PROJECT_DIR" ]; then
    echo "Removing existing directory..."
    rm -rf "$PROJECT_DIR"
fi

git clone $REPO_URL $PROJECT_DIR || { echo "Failed to clone repository, exiting."; exit 1; }

cd $DOCKERFILE_PATH || { echo "Directory not found, exiting."; exit 1; }

POSTGRES_HOST=$(terraform output -raw postgres_endpoint)
MONGO_URL="mongodb://myadminuser:password@$(terraform output -raw mongo_endpoint):27017/schedules"
REDIS_HOST=$(terraform output -raw redis_endpoint)

export REACT_APP_API_BASE_URL=http://3.68.108.87:8080
export POSTGRES_HOST=$POSTGRES_HOST
export POSTGRES_PORT=5432
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=password
export MONGO_URL=$MONGO_URL
export REDIS_HOST=$REDIS_HOST
export REDIS_PORT=6379
export TOKEN=$repo_token

sudo docker build -t backend . || { echo "Failed to build the Docker image, exiting."; exit 1; }

sudo docker run -d -p 8080:8080 backend || { echo "Failed to run the Docker container, exiting."; exit 1; }
