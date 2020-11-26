#!/bin/bash
for f in `find tests -name failed`; do 
    DIR=`dirname $f`

    if [ ! -f $DIR/disabled ] ; then
        echo `dirname $f`
    fi
done | xargs ghul-test
