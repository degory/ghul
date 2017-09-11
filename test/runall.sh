#!/bin/bash

CAPTURE=$1

let failed=0

export QUIET=1

let total=0
let passed=0
let failed=0

for d in cases/* ; do
	if [ -d $d ] && [ ! -f $d/disabled ] ; then
        i=`basename $d`
	    if ./run.sh $i $CAPTURE ; then
            echo "$i: passed"
            let passed=passed+1
        else
            echo "$i: FAILED"
            let failed=failed+1
        fi

        let total=total+1        
	fi
done

echo "passed: $passed/$total"
echo "failed: $failed/$total"

if [[ $failed == 0 ]] ; then
    echo "PASSED"  
else
    echo "FAILED"
fi

exit $failed
