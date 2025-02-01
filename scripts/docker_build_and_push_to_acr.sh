#!/bin/bash

# Build the Docker image and push the Docker image to the Azure Container Registry.
#
# Requirements:
# chmod +x docker_build_and_push_to_acr.sh

SUBSCRIPTION_ID="$1"
IMAGE_NAME="$2"
IMAGE_TAG="$3"
REGISTRY_NAME="$4"
DOCKERFILE_PATH="$5"
DOCKERFILE_CONTEXT="$6"

az account set --subscription $SUBSCRIPTION_ID

az acr build -t $IMAGE_NAME:$IMAGE_TAG -r $REGISTRY_NAME -f $DOCKERFILE_PATH $DOCKERFILE_CONTEXT