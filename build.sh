#!/bin/bash
if [ -z "$JOB_NAME" ]; then
    export JOB_NAME=rewrite-ci
fi

if [ ! -d /tmp/lcache-$JOB_NAME ]; then
    mkdir /tmp/lcache-$JOB_NAME
fi

export LFLAGS="$LFLAGS -p $JOB_NAME"

# find ghul ioc system logging source lexical syntax -name '*.l' -o -name '*.ghul' | xargs ghul -o ghul/ghul imports.l -E -L
find ghul ioc system logging source lexical syntax -name '*.l' | xargs ghul -o ghul/ghul imports.l