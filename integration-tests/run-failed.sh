#!/bin/bash
for f in `find integration-tests -name failed`; do 
    DIR=`dirname $f`

    if [ ! -f "$DIR/disabled" ] ; then
        echo $DIR
    fi
done | xargs dotnet ghul-test
