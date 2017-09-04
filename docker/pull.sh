#!/bin/bash
if [ -z "$1" ]; then
    echo "no image name specified"
    exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
    echo "Pull latest version of $1..."
    
    docker pull docker.giantblob.com/$1:latest
else
    echo "Pull version $BUILD_NUMBER of $1..."

    docker pull docker.giantblob.com/$1:$BUILD_NUMBER
fi




