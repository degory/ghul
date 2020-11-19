#!/bin/bash
set -e

if [ -z "$BUILD_NAME" ] ; then
    export BUILD_NAME="bootstrap-`date +'%s'`"
fi

export LIB=./lib

./build/build.sh
GHUL=./ghul.exe ./build/build.sh
mv out.il stage-2.il
GHUL=./ghul.exe ./build/build.sh
mv out.il stage-3.il
diff stage-2.il stage-3.il
# rm stage-2.il stage-3.il
