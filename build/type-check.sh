#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >src/source/build.ghul

find src -name '*.ghul' | xargs ./ghul -G -p ./lib -l legacy/ghul