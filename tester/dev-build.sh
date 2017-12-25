#!/bin/bash

LCACHE=lcache-test
docker volume create $LCACHE

docker run --rm -e LFLAGS="-FB -FN" -v ${LCACHE}:/tmp/lcache/ -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` ghul/compiler:stable ./build.sh
