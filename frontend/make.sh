#!/bin/bash

# Auto-build the Docker image and execute the Docker container on frontend application changes.
# Requirements:
# - Docker
# - https://github.com/ggreer/the_silver_searcher

while sleep 1; do
  ag -l | entr -cdrs 'docker stop azure-visualisation | docker rm azure-visualisation | docker run --name azure-visualisation --rm -d -p 80:80 --init $(docker build -t azure-visualisation -q .)'
done

# Access the build directory
# docker run --name azure-visualisation -p 80:80 -v $(pwd)/build:/development/build azure-visualisation:latest