#!/bin/bash
if [ -z "$JOB_NAME" ]; then
    export JOB_NAME=rewrite-ci
fi

if [ ! -d /tmp/lcache-$JOB_NAME ]; then
    mkdir /tmp/lcache-$JOB_NAME
fi

find ghul ioc system logging source lexical syntax -name '*.l' | xargs lc -p $JOB_NAME
