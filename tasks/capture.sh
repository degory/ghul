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

# Matches how the runner reads the same flag, so the two cannot drift on
# what counts as a library.
is_library() {
    local flag

    for flag in $(cat "$CASE/ghulflags" 2>/dev/null) ; do
        if [ "$flag" = "--library" ] ; then
            return 0
        fi
    done

    return 1
}

if [ -d $CASE ] ; then
    if [ ! -f $CASE/failed ] ; then
        echo "expected to find failed marker in $CASE"
        exit 1
    fi

    promote $CASE/err.sort $CASE/err.expected
    promote $CASE/warn.sort $CASE/warn.expected
    promote $CASE/il.out $CASE/il.expected
    promote $CASE/format.out $CASE/format.expected

    # A library has no entry point, so the runner never runs it and there
    # is no run output to promote - which is not the same as the build
    # having failed. Writing fail.expected for one makes the test demand
    # a build failure it is not testing for, and it then reports
    # "unexpected build success" forever after.
    if [ -f $CASE/run.out ] ; then
        promote $CASE/run.out $CASE/run.expected
        rm -f $CASE/fail.expected
    elif ! is_library ; then
        echo >$CASE/fail.expected
    fi

    exit 0
else
    echo "doesn't seem to be a test case: $CASE"
    exit 1
fi

