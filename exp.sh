#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >source/build.ghul

find compiler driver ioc system logging source lexical syntax semantic ir lib -name '*.ghul' |  xargs ./ghul -G -X $GHULFLAGS 
