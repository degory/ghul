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

if [ -z "${PACKAGE_VERSION}" ] ; then
    PACKAGE_VERSION="${TAG_VERSION:1}"
fi

echo "Bootstrapping tag version ${TAG_VERSION} to produce package version ${PACKAGE_VERSION}"

export CI=1 

VERBOSITY="-verbosity:normal"

echo "namespace Source is class BUILD is number: string static => \"${TAG_VERSION}\"; si si" >src/source/build.ghul

for PASS in 1 2 3 ; do
    echo
    echo "Start pass ${PASS}..."

    if [ "${PASS}" == "1" ] ; then
        export GHUL="ghul-compiler"
    else
        export GHUL="./bin/Debug/net6.0/publish/ghul"
    fi

    RUN="dotnet publish -nologo ${VERBOSITY} -p:GhulCompiler=\"${GHUL}\" -p:Version=${PACKAGE_VERSION} -consoleloggerparameters:NoSummary"
    echo ${RUN} ; ${RUN}    

    if [ "${PASS}" == "3" ] ; then
        RUN="dotnet pack -nologo ${VERBOSITY} -p:GhulCompiler=\"${GHUL}\" -p:Version=${PACKAGE_VERSION} -consoleloggerparameters:NoSummary"
        echo ${RUN} ; ${RUN}
    else
        dotnet clean -nologo -verbosity:quiet
    fi

    if [ "${PASS}" != "1" ] ; then
        mv out.il stage-${PASS}.il
    fi

    echo
    echo "Finished pass ${PASS}..."
done

diff stage-2.il stage-3.il

echo
echo "Bootstrapped `./bin/Debug/net6.0/publish/ghul`"
