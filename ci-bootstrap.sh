#!/bin/bash

set -e

export MSYS_NO_PATHCONV=1

export LFLAGS="${LFLAGS} -Ws -WM"

BUILD_WITH=ghul/compiler:stable
docker pull $BUILD_WITH

if [ -z "$BUILD_NUMBER" ]; then
    echo "No build number set"
    exit 1;
fi

echo $BUILD_NUMBER: Starting bootstrap...

for PASS in "${BUILD_NUMBER}-1" "${BUILD_NUMBER}-2" "${BUILD_NUMBER}" ; do
    echo $PASS: Start compile...

    echo "namespace Source is class BUILD is public static System.String number=\"$PASS\"; si si" >source/build.l

    docker run --name "bootstrap-`date +'%s'`" --rm -e LFLAGS="$LFLAGS" -e GHUL=/usr/bin/ghul -v `pwd`:/home/dev/source -w /home/dev/source -u `id -u`:`id -g` $BUILD_WITH bash -c ./build.sh || exit 1

    echo $PASS: Compilation complete
    
    echo $PASS: Build image...

    BUILD_WITH=ghul:$PASS

    docker build . -t $BUILD_WITH || exit 1

    echo $PASS: Image built

    if [ "$PASS" == "${BUILD_NUMBER}" ]; then
        pushd tester

        echo $PASS: Build tester...

        ./dev-build.sh

        popd

        echo $PASS: Start tests... 

        docker run --name "bootstrap-`date +'%s'`" --rm -v test-lcache:/tmp/lcache -v `pwd`:/home/dev/source/ -w /home/dev/source/test -u `id -u`:`id -g` $BUILD_WITH ../tester/tester

        echo $PASS: Tests complete
    fi
done

echo $BUILD_NUMBER: Bootstrap complete, pushing release candidate image to repository...

docker tag ghul:$PASS ghul/compiler:release-candidate || exit 1
docker push ghul/compiler:release-candidate || exit 1

docker tag ghul:$PASS ghul/compiler:${BUILD_NUMBER} || exit 1
docker push ghul/compiler:${BUILD_NUMBER} || exit 1
