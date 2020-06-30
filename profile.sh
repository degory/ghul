#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >source/build.ghul

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul`
fi

export LFLAGS="-Ws -WM -FB -FN"

echo "Profiling $GHUL (`$GHUL`)..."
find lib compiler driver ioc system logging source lexical syntax semantic ir -name '*.ghul' | xargs valgrind --tool=callgrind $GHUL -D -P ghul -G -X -o ghul imports.l
