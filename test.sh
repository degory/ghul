#!/bin/bash
export GHULFLAGS="-E -L $GHULFLAGS"
export GHUL=`pwd`/ghul
echo Testing "$GHUL (`$GHUL`)"

cd test

pwd

if [ ! -z $1 ] ; then
    ./run.sh $1
else
    ./runall.sh
fi
   
