#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >src/source/build.ghul

echo "Building with ./ghul (`./ghul`) for .NET target..."
find src -name '*.ghul' | xargs mono ./ghul.exe -p ./lib -o ghul.exe