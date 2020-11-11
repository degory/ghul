#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'-stage-3`\"; si si" >src/source/build.ghul

echo "Building with ./ghul.exe (`mono ./ghul.exe`) for .NET target..."
find src -name '*.ghul' | xargs dotnet ./ghul-s2.exe -p ./lib -o ghul-s3.exe