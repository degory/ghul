#!/bin/bash

ARG=$1

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
else
    CASE=`echo test/cases/$ARG*`

    if [ -d $CASE ] ; then
        TEST=`basename $CASE`
        echo "Run test case $TEST"
    else
        echo "Not a test case or a test source file $ARG, running all tests"
    fi
fi

docker run --rm --env PATH='/home/dev/source:/bin:/usr/bin:/usr/local/bin' -v test-lcache:/tmp/lcache -v `pwd`:/home/dev/source/ -w /home/dev/source/test -u `id -u`:`id -g` ghul/compiler:stable ../tester/tester $TEST

cat test/junit.xml
