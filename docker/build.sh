#!/bin/bash
if [ -z "$1" ]; then
    echo "no image name specified"
    exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
    echo "Building test version of $1..."
    
    docker build --pull $1 -t docker.giantblob.com/$1:test -t docker.giantblob.com/$1:latest
    docker push docker.giantblob.com/$1:test
    docker push docker.giantblob.com/$1:latest    
else
    echo "Building version $BUILD_NUMBER of $1..."
    
    docker build --pull $1 -t docker.giantblob.com/$1:$BUILD_NUMBER -t docker.giantblob.com/$1:latest
    docker push docker.giantblob.com/$1:$BUILD_NUMBER
    docker push docker.giantblob.com/$1:latest   
fi




