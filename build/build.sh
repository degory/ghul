#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >src/source/build.ghul

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul`
fi

export LFLAGS="-Ws -WM -FC"

echo "Building with $GHUL (`$GHUL`)..."
find src -name '*.ghul' | xargs $GHUL -D -P ghul -L $GHULFLAGS -o ghul imports.l lib/ghul.ghul