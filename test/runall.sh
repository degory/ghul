#!/bin/bash

CAPTURE=$1

let i=1
let last=200

let failed=0

mkdir -p tmp

while [ $i -lt $last ] ; do
    # echo "running ${processes} tests from ${from} to ${to}..."
    
        # echo "running test ${j} in ${TMP}..."

	if [ -d cases/$i ] ; then
	    if ./run.sh $i $CAPTURE ; then
            let failed=failed+1
        fi
	fi

    # echo "waiting for ${processes} tests to complete..."

    let i=i+1
done

exit $failed
