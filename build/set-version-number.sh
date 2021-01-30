#!/bin/bash
set -e

if [ -z "${TAG_VERSION}" ] ; then
    TAG_VERSION=v0.0.0
fi

VALID_VERSION_REGEX="^v[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9]+\.[0-9]+)?$"

if [[ ! ${TAG_VERSION} =~ ${VALID_VERSION_REGEX} ]] ; then
    echo "invalid tag version number: ${TAG_VERSION}"
    exit 1
fi

echo "namespace Source is class BUILD is number: string static => \"${TAG_VERSION}\"; si si" >src/source/build.ghul
