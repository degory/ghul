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

if [ -d $CASE ] ; then
    if [ ! -f $CASE/failed ] ; then
        echo "expected to find failed marker in $CASE"
        exit 1
    fi

    if [ -f $CASE/err.sort ] ; then
        mv $CASE/err.sort $CASE/err.expected
    fi

    if [ -f $CASE/warn.sort ] ; then
        mv $CASE/warn.sort $CASE/warn.expected
    fi
    
    if [ -f $CASE/run.out ] ; then
        mv $CASE/run.out $CASE/run.expected
        rm $CASE/fail.expected
    else
        echo >$CASE/fail.expected
    fi

    rm $CASE/failed

    exit 0
else
    echo "doesn't seem to be a test case: $CASE"
    exit 1
fi

