#!/bin/bash

set -e

export LFLAGS="${LFLAGS} -Ws -WM -FC"

if [ -z "$BUILD_WITH" ]; then
    BUILD_WITH=ghul/compiler:stable
fi

docker pull $BUILD_WITH

source ./build/set-build-name.sh

echo $BUILD_NAME: Starting bootstrap...

for PASS in "ghul/bootstrap:${BUILD_NAME}-1" "ghul/bootstrap:${BUILD_NAME}-2" "ghul/bootstrap:${BUILD_NAME}" ; do
    echo $PASS: Start compile...

    echo "namespace Source is class BUILD is number: System.String public static => \"${PASS}\"; si si" >src/source/build.ghul

    docker run --name "bootstrap-`date +'%s'`" --rm -e LFLAGS="$LFLAGS" -e GHUL=/usr/bin/ghul -v `pwd`:/home/dev/source -w /home/dev/source -u `id -u`:`id -g` $BUILD_WITH /bin/sh ./build/_build.sh || exit 1

    echo $PASS: Compilation complete

    echo $PASS: Build installer...

    ./build/make-installer.sh

    echo $PASS: Build image...

    BUILD_WITH=$PASS

    docker build -f legacy.dockerfile --pull -t $BUILD_WITH . || exit 1

    echo $PASS: Image built
done

echo Complete
