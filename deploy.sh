#!/bin/bash
set -e
echo pull
docker pull ghul/compiler:release-candidate
echo tag
docker tag ghul/compiler:release-candidate ghul/compiler:stable
echo push
docker push ghul/compiler:stable

if [ ! -z $DOCKER_REGISTRY_2 ]; then
    echo tag
    docker tag ghul/compiler:release-candidate ${DOCKER_REGISTRY_2}/compiler:stable || exit 1
    echo push
    docker push ${DOCKER_REGISTRY_2}/compiler:stable || exit 1
fi

echo done


