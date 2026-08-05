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

# An empty expectation file asserts exactly what no file at all asserts: the
# runner diffs the produced output against /dev/null when the expectation is
# missing, so either way the test demands empty output. Promoting an empty
# result adds a file that can never change a test's outcome, and err.sort and
# warn.sort are produced for every test whether or not anything was written to
# them. Drop empty results instead, clearing any expectation the test has
# outgrown.
#
# fail.expected is not one of these — it signals by its presence alone and its
# contents are ignored — so it is handled separately below.
promote() {
    local produced=$1 expectation=$2

    if [ ! -f "$produced" ] ; then
        return
    fi

    if [ -s "$produced" ] ; then
        mv "$produced" "$expectation"
    else
        rm -f "$produced" "$expectation"
    fi
}

if [ -d $CASE ] ; then
    if [ ! -f $CASE/failed ] ; then
        echo "expected to find failed marker in $CASE"
        exit 1
    fi

    promote $CASE/err.sort $CASE/err.expected
    promote $CASE/warn.sort $CASE/warn.expected
    promote $CASE/il.out $CASE/il.expected

    if [ -f $CASE/run.out ] ; then
        promote $CASE/run.out $CASE/run.expected
        rm -f $CASE/fail.expected
    else
        echo >$CASE/fail.expected
    fi

    exit 0
else
    echo "doesn't seem to be a test case: $CASE"
    exit 1
fi

