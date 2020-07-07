#!/bin/bash
if [ ! -d /tmp/lcache ]; then
    mkdir /tmp/lcache
fi

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul`
fi

echo "Building with $GHUL (`$GHUL`)..."
find src -name '*.ghul' | xargs $GHUL -L $GHULFLAGS -o tester imports.l
