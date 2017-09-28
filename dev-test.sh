#!/bin/bash

if [[ $1 =~ .ghul$ ]] ; then
    CASE=`dirname $1`
    NAME=`basename $CASE`
    PARENT=`dirname $CASE`

    if [[ $PARENT =~ test/cases$ ]] ; then
        echo "Run test containing $1, test case $NAME"

        ARGUMENT=$NAME
    else
        echo "Run all tests"
    fi
elif [ -z $1 ] ; then
    echo "Run all test cases"
elif [[ -d test/cases/$1 ]] ; then
    echo "Run test case $1"
    ARGUMENT=$1
else
    CASE=`echo test/cases/$1*`

    if [ -d $DIRECTORY ] ; then
        ARGUMENT=`basename $CASE`
        echo "Run test case $ARGUMENT"
    else
        echo "Not a test case or a test source file $1, running all tests"
    fi
fi

docker run -e GHULFLAGS -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -t ghul/compiler:stable ./test.sh $ARGUMENT
