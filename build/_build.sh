#!/bin/bash

# Build the ghul compiler running the L compiler directly rather than in a Docker container. Unless you have all L dependencies installed, you probably want to use build.sh instead

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
find src -name '*.ghul' | xargs $GHUL -L -G $GHULFLAGS -o ghul imports.l
