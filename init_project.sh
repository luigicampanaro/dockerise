#!/bin/bash

# Move to the parent directory and get its name
PARENT_DIR=$(dirname "$(pwd)")
MAIN_FOLDER_NAME=$(basename "$PARENT_DIR")

# Convert MAIN_FOLDER_NAME to a Docker-compatible format
# Replace spaces with underscores, convert to lowercase
DOCKER_COMPATIBLE_CONTAINER_NAME=$(echo "$MAIN_FOLDER_NAME" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '_')

# Export the environment variable
export PARENT_DIR

# Get args for the docker compose
USERNAME=$(whoami)
USER_UID=$(id -u)
USER_GID=$(id -g)

# Create the .env file with the required variables
cat <<EOF > .env
MAIN_FOLDER_NAME=$MAIN_FOLDER_NAME
USERNAME=$USERNAME
UID=$USER_UID
GID=$USER_GID
DOCKER_COMPATIBLE_CONTAINER_NAME=$DOCKER_COMPATIBLE_CONTAINER_NAME
EOF

# Create the folders in the main project directory
mkdir -p "$PARENT_DIR/src"
mkdir -p "$PARENT_DIR/data"
mkdir -p "$PARENT_DIR/logs"

# Launch container build
docker compose -f docker-compose.yml build --no-cache