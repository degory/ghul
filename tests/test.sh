#!/bin/bash

PATH=`pwd`:$PATH

pushd `dirname "$0"` >/dev/null

../tester/tester

RESULT=$?

popd >/dev/null

exit $RESULT