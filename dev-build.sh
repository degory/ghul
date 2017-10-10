#!/bin/bash

if [[ -d /tmp/lcache-dev ]]; then
    LCACHE=/tmp/lcache-dev
else
    docker volume create lcache
    LCACHE=lcache
fi

echo "namespace Source is class BUILD is public static System.String number=\"local\"; si si" >source/build.l

MSYS_NO_PATHCONV=1 \
docker run --rm -e LFLAGS="-FB -FN" -v ${LCACHE}:/tmp/lcache/ -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -t ghul/compiler:stable ./build.sh
