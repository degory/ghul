#!/bin/bash
export GHULFLAGS="-E -L"
export GHUL=../ghul
pushd test
./run.sh $1 capture
    
