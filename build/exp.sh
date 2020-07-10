#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >src/source/build.ghul

find src lib -name '*.ghul' |  xargs ./ghul -G -X $GHULFLAGS 
