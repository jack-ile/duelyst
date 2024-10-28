#!/usr/bin/env bash

# Helper function for error handling.
quit () {
	echo $1
	exit 1
}

# Parse arguments.
SERVICE=$1
if [ -z $SERVICE ]; then quit "Usage: build_container.sh <service> <version>"; fi
VERSION=$2
if [ -z $VERSION ]; then VERSION=testing; fi

# Rebuild the base Node.js image if needed.
echo "Building image for duelyst-nodejs:$VERSION."
docker build \
	-f docker/nodejs.Dockerfile \
	-t duelyst-nodejs:$VERSION \
	--platform=linux/amd64 \
	. || quit "Failed to build Node.js image!"
#TODO: make --platform=linux/arm64 arguement an input parameter for release_containers.sh

# Build the service image.
docker build \
	-f docker/$SERVICE.Dockerfile \
	-t duelyst-$SERVICE:$VERSION \
	--build-arg NODEJS_IMAGE_VERSION=$VERSION \
	--platform=linux/amd64 \
	. || quit "Failed to build service image!"
#TODO: make --platform=linux/arm64 arguement an input parameter for release_containers.sh

echo "Successfully built image duelyst-${SERVICE}:${VERSION}"
