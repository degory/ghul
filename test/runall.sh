#!/bin/bash

CAPTURE=$1

let i=1
let last=200

let failed=0

mkdir -p tmp

export QUIET=1

while [ $i -lt $last ] ; do
	if [ -d cases/$i ] ; then
	    if ./run.sh $i $CAPTURE ; then
            echo "$i: passed"
        else
            echo "$i: FAILED"
            let failed=failed+1
        fi
	fi

    let i=i+1
done

echo "$failed tests failed"

exit $failed
