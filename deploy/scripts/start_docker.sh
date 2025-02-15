#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 471112948185.dkr.ecr.us-east-1.amazonaws.com

echo "Pulling Docker image..."
docker pull 471112948185.dkr.ecr.us-east-1.amazonaws.com/youtube-chrome-plugin:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=sentify-app)" ]; then
    echo "Stopping existing container..."
    docker stop sentify-app
fi

if [ "$(docker ps -aq -f name=sentify-app)" ]; then
    echo "Removing existing container..."
    docker rm sentify-app
fi

# container name: sentify-app
echo "Starting new container..."
docker run -d -p 80:8000 --name sentify-app 471112948185.dkr.ecr.us-east-1.amazonaws.com/youtube-chrome-plugin:latest

echo "Container started successfully."
