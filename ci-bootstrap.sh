#!/bin/bash

if [ -z "$BUILD_WITH" ]; then
    BUILD_WITH=docker.giantblob.com/ghul:stable
    docker pull $BUILD_WITH || exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
    BUILD_NUMBER=ad-hoc
fi

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

echo $BUILD_NUMBER: Bootstrap complete, pushing stable image to repository...

docker tag ghul:$PASS docker.giantblob.com/ghul:${BUILD_NUMBER} || exit 1
docker tag ghul:$PASS docker.giantblob.com/ghul:release-candidate || exit 1
docker push docker.giantblob.com/ghul:${BUILD_NUMBER} || exit 1
docker push docker.giantblob.com/ghul:release-candidate || exit 1

docker tag ghul:$PASS degory/ghul:${BUILD_NUMBER} || echo "Could not push to public Docker registry"
docker tag ghul:$PASS degory/ghul:release-candidate || echo "Could not push to public Docker registry"
docker push degory/ghul:${BUILD_NUMBER} || echo "Could not push to public Docker registry"
docker push degory/ghul:release-candidate || echo "Could not push to public Docker registry"

