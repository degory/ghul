#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'-stage-2`\"; si si" >src/source/build.ghul

echo "Building with ./ghul.exe (`mono ./ghul.exe`) for .NET target..."
if [ -f ghul-s2.exe ] ; then rm ghul-s2.exe ; fi
find src -name '*.ghul' | xargs mono ./ghul.exe -p ./lib -o ghul-s2.exe
if [ -f ghul-s2.exe ] ; then mv ghul-s2.exe ghul.exe ; mono --aot=full -O=all ghul.exe ; fi
