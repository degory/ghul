#!/bin/bash
if [ -z "$JOB_NAME" ]; then
    export JOB_NAME=rewrite-ci
fi

if [ ! -d /tmp/lcache-$JOB_NAME ]; then
    mkdir /tmp/lcache-$JOB_NAME
fi

export LFLAGS="$LFLAGS -p $JOB_NAME"

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul`
fi

echo "Building with $GHUL (`$GHUL`)..."
find driver ioc system logging source lexical syntax -name '*.ghul' |  xargs $GHUL -E -L -o ghul imports.l source/*.l
# find driver ioc system logging source lexical syntax -name '*.l' -o -name '*.ghul' |  xargs $GHUL -E -L -o ghul imports.l
