#!/bin/bash

if [ ! -f src/source/build.ghul ] ; then
    echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >src/source/build.ghul
fi

if [ "$1" != "no-docker" ] ; then
    WANT_DOCKER="-D"
fi

if [ "$1" != "no-docker" ] ; then
    WANT_DOCKER="-D"
fi

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul`
fi

export LFLAGS="-Ws -WM -FC"

echo "Building with $GHUL (`$GHUL`)..."
find src -name '*.ghul' | xargs $GHUL $WANT_DOCKER -L -o ghul imports.l