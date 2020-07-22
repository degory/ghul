#!/bin/bash
CASE=$1

if [ ! -d $CASE ] ; then
    echo "not run from a test case project"
    exit 1;
fi

if [ ! -f $CASE/ghulflags ] ; then
    echo "not run from a test case project"
    exit 1;
fi

docker run --name "test-`date +'%s'`" --rm --env PATH='/home/dev/source:/bin:/usr/bin:/usr/local/bin' -v `pwd`/../../..:/home/dev/source/ -w /home/dev/source/test -u `id -u`:`id -g` ghul/compiler:stable ../tester/tester ${@:1}

