#!/bin/bash

REPO_URL="https://<annasever>:$TOKEN@github.com/annasever/internship_project.git"
PROJECT_DIR="/home/ubuntu/internship_project"
DOCKERFILE_PATH="$PROJECT_DIR"
export TOKEN=$repo_token

if [ -d "$PROJECT_DIR" ]; then
    echo "Removing existing directory..."
    rm -rf "$PROJECT_DIR"
fi

git clone $REPO_URL $PROJECT_DIR || { echo "Failed to clone repository, exiting."; exit 1; }

cd $DOCKERFILE_PATH || { echo "Directory not found, exiting."; exit 1; }

export REACT_APP_API_BASE_URL=http://<Private_IP_of_Backend>:8080

sudo docker build -t frontend . || { echo "Failed to build the Docker image, exiting."; exit 1; }

sudo docker run -d -p 3000:3000 frontend || { echo "Failed to run the Docker container, exiting."; exit 1; }

