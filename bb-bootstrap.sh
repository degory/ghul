#!/bin/bash
echo "Bootstrap pass 1..."
export GHUL=/usr/bin/ghul
./clean.sh
./build.sh && \
./test.sh || \
exit 1
echo "Bootstrap pass 2..."
export GHUL=`pwd`/ghul
./clean.sh
./build.sh && \
./test.sh || \
exit 1
echo "Bootstrap pass 3..."
./clean.sh
./build.sh && \
./test.sh || \
exit 1
echo "Bootstrap succeeded"
