#!/bin/bash
export GHULFLAGS="-E -L"
export GHUL=../ghul/ghul
pushd test
./runall.sh capture
    
