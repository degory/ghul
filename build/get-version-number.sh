#!/bin/bash
PROPS=$1

if [ "${PROPS}" == "" ] ; then
    PROPS="./Directory.Build.props"
fi

grep -o '[0-9]*\.[0-9]*\.[0-9]*-alpha\.[0-9]*' ${PROPS}