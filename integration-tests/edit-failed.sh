#!/bin/bash

FAILED=""

for f in $(find integration-tests -name failed); do
    DIR=$(dirname "$f")

    if [ ! -f "$DIR/disabled" ]; then
        FAILED="$FAILED $DIR"
    fi
done

if [ -n "$FAILED" ]; then
    code $FAILED
fi
