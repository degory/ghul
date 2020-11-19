#!/bin/bash

set -e

cp source-files-backup.txt source-files.txt

# cp source-files.txt source-files-original.txt

mkdir -p ./output

for i in {1..50}; do
    cp source-files-original.txt source-files.txt
    
    csplit source-files.txt 50

    # sort xx01 >xx02
    # cat xx01 xx02 >source-files.txt

    shuf xx00 >xx02
    cat xx02 xx01 >source-files.txt

    cp source-files.txt output/source-${i}.txt

    rm xx00 xx01 xx02

    ./build/bootstrap.sh

    cp stage-3.il output/output-${i}.txt
done
