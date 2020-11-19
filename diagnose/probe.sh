#!/bin/bash

set -e

# cp source-files.txt source-files-original.txt

FROM=6
TO=7

mkdir -p ./output

csplit source-files-input.txt $FROM $TO

cat xx00 xx02 >combined.txt
mv xx01 pick.txt

for i in {6..232}; do
    echo "splitting at line $i"
    
    csplit combined.txt $i

    cat xx00 pick.txt xx01 >source-files.txt

    cp source-files.txt output/source-${i}.txt

    rm xx00 xx01

    ./build/bootstrap.sh

    cp stage-3.il output/output-${i}.txt
done
