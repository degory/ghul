#!/bin/bash

if [[ -d /tmp/lcache-dev ]]; then
    LCACHE=/tmp/lcache-dev
else
    docker volume create lcache
    LCACHE=lcache
fi

MSYS_NO_PATHCONV=1 \
docker run --name "dev-`date +'%s'`" --rm -v ${LCACHE}:/tmp/lcache -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -it ghul/compiler:stable /bin/bash
