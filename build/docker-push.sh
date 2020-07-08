#!/bin/bash
set -e

source ./build/set-build-name.sh

echo pull
docker pull ghul/compiler:${BUILD_NAME}
echo tag
docker tag ghul/compiler:${BUILD_NAME} ghul/compiler:stable
echo push
docker push ghul/compiler:stable

if [ ! -z $DOCKER_REGISTRY_2 ]; then
    echo tag
    docker tag ghul/compiler:${BUILD_NAME} ${DOCKER_REGISTRY_2}/compiler:stable || exit 1
    echo push
    docker push ${DOCKER_REGISTRY_2}/compiler:stable || exit 1
fi

echo done


