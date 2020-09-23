#!/bin/bash

if [ -z "$BUILD_WITH" ] ; then
    BUILD_WITH="ghul/compiler:stable"
fi

docker run --name "test-`date +'%s'`" --rm --env PATH='/home/dev/source:/bin:/usr/bin:/usr/local/bin' -v `pwd`:/home/dev/source/ -w /home/dev/source/tests-legacy -u `id -u`:`id -g` ${BUILD_WITH} ../tester/tester

