#!/bin/bash

set -e

BUILD_WITH=ghul/compiler:stable
docker pull $BUILD_WITH

if [ -z "$BUILD_NUMBER" ]; then
    echo "No build number set"
    exit 1;
fi

# pull the latest legacy compiler image and push to public repo
# so it's available for development builds:
docker pull docker.giantblob.com/ex
docker tag docker.giantblob.com/ex ghul/llc:${BUILD_NUMBER}
docker push ghul/llc:${BUILD_NUMBER}

echo $BUILD_NUMBER: Starting bootstrap...

for p in 1 2 bs ; do
    PASS=${BUILD_NUMBER}-${p}

    echo $PASS: Start compile...

    echo "namespace Source is class BUILD is public static System.String number=\"$PASS\"; si si" >source/build.l

    docker run -e GHUL=/usr/bin/ghul -v `pwd`:/home/dev/source -w /home/dev/source -u `id -u`:`id -g` -t $BUILD_WITH bash -c ./build.sh || exit 1

    echo $PASS: Compilation complete

    echo $PASS: Start tests... 

    docker run -v `pwd`:/home/dev/source -w /home/dev/source -u `id -u`:`id -g` -t $BUILD_WITH /bin/bash ./test.sh || exit 1

    echo $PASS: Tests complete
    echo $PASS: Build image...

    BUILD_WITH=ghul:$PASS

    docker build --pull . -t $BUILD_WITH || exit 1

    echo $PASS: Image built
done

echo $BUILD_NUMBER: Bootstrap complete, pushing release candidate image to repository...

docker tag ghul:$PASS ghul/compiler:release-candidate || exit 1
docker push ghul/compiler:release-candidate || exit 1

docker tag ghul:$PASS ghul/compiler:${BUILD_NUMBER} || exit 1
docker push ghul/compiler:${BUILD_NUMBER} || exit 1
