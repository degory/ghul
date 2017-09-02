#!/bin/bash
export GHULFLAGS="-E -L $GHULFLAGS"
export GHUL=../ghul/ghul
pushd test
if [ ! -z $1 ] ; then
    ./run.sh $1
else
    ./runall.sh
fi
   
