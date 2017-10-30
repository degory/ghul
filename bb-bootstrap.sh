#!/bin/bash
echo "Bootstrap pass 1..."
echo "namespace Source is class BUILD is public static System.String number=\"bb-1\"; si si" >source/build.l
export GHUL=/usr/bin/ghul
./clean.sh
./build.sh && \
./test.sh || \
exit 1
echo "Bootstrap pass 2..."
echo "namespace Source is class BUILD is public static System.String number=\"bb-2\"; si si" >source/build.l
export GHUL=`pwd`/ghul
./clean.sh
./build.sh && \
./test.sh || \
exit 1
echo "Bootstrap pass 3..."
echo "namespace Source is class BUILD is public static System.String number=\"bb-bs\"; si si" >source/build.l
./clean.sh
./build.sh && \
./test.sh || \
exit 1
echo "Bootstrap succeeded"
