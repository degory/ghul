#!/bin/bash
for f in `find integration-tests -name failed`; do 
    DIR=`dirname $f`

    if [ ! -f $DIR/disabled ] ; then
        code `dirname $f` ; read -n 1 -s
    fi
done
