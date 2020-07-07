#!/bin/bash

LCACHE=lcache-test
docker volume create $LCACHE

docker run --name "dev-`date +'%s'`" --rm -e LFLAGS="-FB -FN -Ws -WM" -v ${LCACHE}:/tmp/lcache/ -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` ghul/compiler:stable ./_build.sh
