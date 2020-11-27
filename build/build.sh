#!/bin/bash

set -e

if [ -z "$BUILD_NAME" ] ; then
    export BUILD_NAME="local-`date +'%s'`"
fi

echo "namespace Source is class BUILD is number: System.String static => \"$BUILD_NAME\"; si si" >src/source/build.ghul

if [ -z "$GHUL" ]; then
    export PATH=$PATH:`pwd`
    export GHUL=`which ghul.exe`
fi

if [ -z "$LIB" ]; then
    export LIB=./lib
fi

if [ $DEBUG ]; then
    export DEBUG_OPTION=--debug
fi

if [ $CI ]; then
    export RELEASE_OPTION="--define release"
fi

if [ -z "$HOST" ] ; then
    if [ -x "`command -v dotnet`" ] ; then
        HOST="dotnet"
    elif [ -x "`command -v mono`" ] ; then
        HOST="mono"
    else
        echo "No CLI found"
        exit 1
    fi
fi

echo "Building with $GHUL (`$HOST $GHUL`) on $HOST for .NET target..."

if [ -z "$SOURCE_FILES" ] ; then
    export SOURCE_FILES=`find src -name '*.ghul'`
fi

mkdir -p out

echo $HOST $GHUL $DEBUG_OPTION $RELEASE_OPTION -p $LIB -o out/ghul.exe

echo $SOURCE_FILES | xargs $HOST $GHUL $DEBUG_OPTION $RELEASE_OPTION -p $LIB -o out/ghul.exe

if [ -f out/ghul.exe ] ; then
    mv -f out/ghul.exe .
fi

if [ -f out/ghul-new.exe.mdb ] ; then
    mv -f out/ghul.exe.mdb .
fi

if [ -f out/ghul.runtimeconfig.json ] ; then
    mv -f out/ghul.runtimeconfig.json .
fi