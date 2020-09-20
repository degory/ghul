#!/bin/bash

# Build the ghul compiler running the L compiler directly rather than in a Docker container. Unless you have all L dependencies installed, you probably want to use build.sh instead

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul`
fi

echo "Building with $GHUL (`$GHUL`)..."
find src -name '*.ghul' | xargs $GHUL -L $GHULFLAGS -o ghul imports.l
