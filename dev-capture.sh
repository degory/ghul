#!/bin/bash

if [ -z $1 ] ; then
    echo "usage: ./dev-capture.sh test-case-name"
    exit 1
fi

CASE=`echo test/cases/$1*`

if [ -d $CASE ] ; then
    ARGUMENT=`basename $CASE`
else
    ARGUMENT=$1
fi

MSYS_NO_PATHCONV=1 \
docker run --name "capture-`date +'%s'`" --rm -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -t ghul/compiler:stable ./capture.sh $ARGUMENT
