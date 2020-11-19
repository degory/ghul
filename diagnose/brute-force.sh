#!/bin/bash

set -e

mkdir -p ./output

for i in {232..1}; do
    echo "splitting at line $i"
    cp source-files-input.txt source-files.txt
    
    csplit source-files.txt $i

    sort xx01 >xx02
    cat xx00 xx02 >source-files.txt

    # shuf xx01 >xx02
    # cat xx00 xx02 >source-files.txt

    # shuf xx00 >xx02
    # cat xx02 xx01 >source-files.txt

    cp source-files.txt output/source-${i}.txt

    rm xx00 xx01 xx02

    ./build/bootstrap.sh

    cp stage-3.il output/output-${i}.txt
done
