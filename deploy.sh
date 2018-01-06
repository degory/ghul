#!/bin/bash
set -e

if [ -z "$BRANCH_NAME" ]; then
    BRANCH_NAME=`git branch | sed -n -e 's/^\* \(.*\)/\1/p'`
fi

echo pull
docker pull ghul/compiler:${BRANCH_NAME}
echo tag
docker tag ghul/compiler:${BRANCH_NAME} ghul/compiler:stable
echo push
docker push ghul/compiler:stable

if [ ! -z $DOCKER_REGISTRY_2 ]; then
    echo tag
    docker tag ghul/compiler:${BRANCH_NAME} ${DOCKER_REGISTRY_2}/compiler:stable || exit 1
    echo push
    docker push ${DOCKER_REGISTRY_2}/compiler:stable || exit 1
fi

echo done


