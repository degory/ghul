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

if [ -z "$LIB " ]; then
    export PREFIX=-p ./lib
fi

echo "Building with $GHUL (`mono $GHUL`) for .NET target..."

if [ -f ghul-new.exe ] ; then rm ghul-new.exe ; fi
cat source-files.txt | xargs mono $GHUL $PREFIX -o ghul-new.exe

mv ghul-new.exe ghul.exe

# if [ -f ghul-new.exe ] ; then mv ghul-new.exe ghul.exe ; mono --aot=full -O=all ghul.exe ; mono ./ghul.exe ; fi
