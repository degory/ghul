#!/bin/bash

if (which cygpath >/dev/nul 2>/dev/nul) ; then
    ARG=`cygpath -a $1`
else
    ARG=$1
fi

if [[ $ARG =~ .ghul$ ]] ; then
    CASE=`dirname $ARG`
    NAME=`basename $CASE`
    PARENT=`dirname $CASE`

    if [[ $PARENT =~ test/cases$ ]] ; then
        echo "Run test containing $ARG, test case $NAME"

        TEST=$NAME
    else
        echo "Run all tests"
    fi
elif [ -z $ARG ] ; then
    echo "Run all test cases"
elif [[ -d test/cases/$ARG ]] ; then
    echo "Run test case $ARG"
    TEST=$ARG
else
    CASE=`echo test/cases/$ARG*`

    if [ -d $CASE ] ; then
        TEST=`basename $CASE`
        echo "Run test case $TEST"
    else
        echo "Not a test case or a test source file $ARG, running all tests"
    fi
fi

MSYS_NO_PATHCONV=1 \
docker run --rm -e GHULFLAGS -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -t ghul/compiler:stable ./test.sh $TEST
