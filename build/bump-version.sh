#!/bin/bash
CURRENT_VERSION=$(grep -o '[0-9]*\.[0-9]*\.[0-9]*-alpha\.[0-9]*' Directory.Build.props) 
VERSION_REGEX='([0-9]+\.[0-9]+\.[0-9]+-[A-Za-z0-9]+\.)([0-9]+)'

if [[ ${CURRENT_VERSION} =~ ${VERSION_REGEX} ]] ; then
    CURRENT_PREFIX=${BASH_REMATCH[1]}
    CURRENT_SUFFIX=${BASH_REMATCH[2]}

    NEXT_VERSION=${CURRENT_PREFIX}$((${CURRENT_SUFFIX} + 1))

    sed -i s/${CURRENT_VERSION}/${NEXT_VERSION}/ Directory.Build.props
fi
