#!/bin/bash
set -e

if [ ! -z '$GITHUB_RUN_ID' ]; then
    BUILD_NUMBER=$GITHUB_RUN_ID
fi

if [ -z "$BUILD_NUMBER" ]; then
    BUILD_NUMBER="ad-hoc-`date +'%s'`"
fi

if [ -z "$BRANCH_NAME" ]; then
    BRANCH_NAME=`git branch | sed -n -e 's/^\* \(.*\)/\1/p'`
fi

BUILD_NAME="${BRANCH_NAME}-${BUILD_NUMBER}"

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


