#!/bin/bash
set -e
./build/build.sh
BUILD_NAME=bootstrap GHUL=./ghul.exe ./build/build.sh
mv out.il stage-2.il
BUILD_NAME=bootstrap GHUL=./ghul.exe ./build/build.sh
mv out.il stage-3.il
diff stage-2.il stage-3.il
rm stage-2.il stage-3.il
