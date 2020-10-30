#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >src/source/build.ghul

echo "Type checking for .NET target..."
find src -name '*.ghul' | xargs ghul -N -G -p ./lib
