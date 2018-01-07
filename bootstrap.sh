#!/bin/bash

set -e

export LFLAGS="${LFLAGS} -Ws -WM -FC"

if [ -z "$BUILD_WITH" ]; then
    BUILD_WITH=ghul/compiler:stable
fi

docker pull $BUILD_WITH

if [ -z "$BUILD_NUMBER" ]; then
    BUILD_NUMBER="ad-hoc-`date +'%s'`"
fi

if [ -z "$BRANCH_NAME" ]; then
    BRANCH_NAME=`git branch | sed -n -e 's/^\* \(.*\)/\1/p'`
fi

echo $BUILD_NUMBER: Starting bootstrap...

BUILD_NAME="${BUILD_NUMBER}-${BRANCH_NAME}"

for PASS in "${BUILD_NAME}-1" "${BUILD_NAME}-2" "${BUILD_NAME}" ; do
    echo $PASS: Start compile...

    echo "namespace Source is class BUILD is public static System.String number=\"${PASS}\"; si si" >source/build.l

    docker run --name "bootstrap-`date +'%s'`" --rm -e LFLAGS="$LFLAGS" -e GHUL=/usr/bin/ghul -v `pwd`:/home/dev/source -w /home/dev/source -u `id -u`:`id -g` $BUILD_WITH bash -c ./build.sh || exit 1

    echo $PASS: Compilation complete
    
    echo $PASS: Build image...

    BUILD_WITH=ghul:$PASS

    docker build . -t $BUILD_WITH || exit 1

    echo $PASS: Image built

    if [ "$PASS" == "${BUILD_NAME}" ]; then
        pushd tester

        echo $PASS: Build tester...

        ./dev-build.sh

        popd

        echo $PASS: Start tests... 

        docker run --name "bootstrap-`date +'%s'`" --rm -v test-lcache:/tmp/lcache -v `pwd`:/home/dev/source/ -w /home/dev/source/test -u `id -u`:`id -g` $BUILD_WITH ../tester/tester

        echo $PASS: Tests complete
    fi
done

echo $BUILD_NUMBER: Bootstrap complete, pushing release candidate docker images...

docker tag ghul:$PASS ghul/compiler:${BRANCH_NAME} || exit 1
docker push ghul/compiler:${BRANCH_NAME} || exit 1

if [ ! -z $DOCKER_REGISTRY_2 ]; then
    docker tag ghul:$PASS ${DOCKER_REGISTRY_2}/compiler:${BRANCH_NAME} || exit 1
    docker push ${DOCKER_REGISTRY_2}/compiler:${BRANCH_NAME} || exit 1
fi

docker tag ghul:$PASS ghul/compiler:${BRANCH_NAME}-${BUILD_NUMBER} || exit 1
docker push ghul/compiler:${BRANCH_NAME}-${BUILD_NUMBER} || exit 1

if [ ! -z $DOCKER_REGISTRY_2 ]; then
    docker tag ghul:$PASS ${DOCKER_REGISTRY_2}/compiler:${BRANCH_NAME}-${BUILD_NUMBER} || exit 1
    docker push ${DOCKER_REGISTRY_2}/compiler:${BRANCH_NAME}-${BUILD_NUMBER} || exit 1
fi