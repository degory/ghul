#!/bin/bash
CASE=$1

if [ ! -d $CASE ] ; then
    echo "not run from a test case project"
    exit 1;
fi

if [ ! -f $CASE/ghulflags ] ; then
    echo "not run from a test case project"
    exit 1;
fi

cd ../..

pushd ..>/dev/null
PATH=`pwd`:${PATH}
popd
CLI_RUNNER=dotnet ../tester/tester ${@:1}

