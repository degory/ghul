#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`-stage-1\"; si si" >src/source/build.ghul

echo "Building with ./ghul (`./ghul`) for .NET target..."

if [ ! -z "$DEBUG" ] ; then
    DEBUG_OPTION="--debug"
    echo "Debug build"
fi

find src -name '*.ghul' | xargs ./ghul $DEBUG_OPTION -p ./lib -o ghul.exe