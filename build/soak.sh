#!/bin/bash
set -e

if [ -z "$BUILD_NAME" ] ; then
    export BUILD_NAME="soak-`date +'%s'`"
fi

export LIB=./lib

GHUL=./ghul.exe ./build/build.sh

for i in {0..49} ; do
    echo "start iteration $i..."
    export SOURCE_FILES=`find src -name '*.ghul' | shuf`

    GHUL=./ghul.exe ./build/build.sh
    mv out.il stage-2.il
    GHUL=./ghul.exe ./build/build.sh
    mv out.il stage-3.il
    diff stage-2.il stage-3.il

    echo "finish iteration $i..."
done

rm stage-2.il stage-3.il
