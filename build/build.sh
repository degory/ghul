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

echo "Building with $GHUL (`mono $GHUL`) for .NET target..."

if [ -f ghul-new.exe ] ; then rm ghul-new.exe ; fi

if [ -f source-files.txt ] ; then
    export SOURCE_FILES=`cat source-files.txt`
else
    export SOURCE_FILES=`find src -name '*.ghul'`
fi

echo $SOURCE_FILES | xargs mono $GHUL $DEBUG_OPTION -p $LIB -o ghul-new.exe

mv ghul-new.exe ghul.exe

if [ -f ghul-new.exe.mdb ] ; then
    mv ghul-new.exe.mdb ghul.exe.mdb
fi

mv ghul-new.runtimeconfig.json ghul.runtimeconfig.json
