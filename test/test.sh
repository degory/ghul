#!/bin/bash

docker run --name "test-`date +'%s'`" --rm --env PATH='/home/dev/source:/bin:/usr/bin:/usr/local/bin' -v test-lcache:/tmp/lcache -v `pwd`:/home/dev/source/ -w /home/dev/source/test -u `id -u`:`id -g` ghul/compiler:stable ../tester/tester ${CASE}

