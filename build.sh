#!/bin/bash
if [ -z "$JOB_NAME" ]; then    
    if [ ! -d /tmp/lcache ]; then
        mkdir /tmp/lcache
    fi
else
    if [ ! -d /tmp/lcache-$JOB_NAME ]; then
        mkdir /tmp/lcache-$JOB_NAME
    fi

    export LFLAGS="$LFLAGS -p $JOB_NAME"
fi

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul`
fi

echo "Building with $GHUL (`$GHUL`)..."
find compiler driver ioc system logging source lexical syntax semantic ir -name '*.ghul' |  xargs $GHUL -L $GHULFLAGS -o ghul imports.l source/*.l
