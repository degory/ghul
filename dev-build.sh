#!/bin/bash

echo "namespace Source is class BUILD is public static System.String number=\"local-`date +'%s'`\"; si si" >source/build.l

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul`
fi

export LFLAGS="-Ws -WM -FB -FN"

echo "Building with $GHUL (`$GHUL`)..."
find compiler driver ioc system logging source lexical syntax semantic llvm ir -name '*.ghul' |  xargs $GHUL -D -P ghul -L $GHULFLAGS -o ghul imports.l source/*.l
