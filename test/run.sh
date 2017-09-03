#!/bin/bash

FAILED=0
if [ "$NAME" = "" ] ; then
    NAME=$1
fi

if [ "$CASE" = "" ] ; then
    CASE=cases/$NAME
fi

if [ "$TMP" = "" ] ; then
    TMP=tmp
fi

if [ -f $CASE/ghulflags ] ; then
    GHULFLAGS="-o binary $GHULFLAGS `cat $CASE/ghulflags`"
fi

LCACHE="/tmp/lcache"
BINARY="binary"

if ! [ -d $LCACHE ] ; then
    mkdir $LCACHE
fi

rm -f $BINARY ${BINARY}.bc ${BINARY}.lh ${LCACHE}/* ${TMP}/* 2>/dev/null

if [ "$GHUL" = "" ] ; then
    GHUL=ghul
fi

echo "${NAME}: compile ..."
$GHUL $GHULFLAGS $CASE/*.ghul 2>$TMP/err_out
# mv test $CASE

if [ -z "$QUIET" ] ; then
    cat $TMP/err_out
fi

grep error: $TMP/err_out | sort >$TMP/err
grep warn: $TMP/err_out | sort >$TMP/warn
if [ "$2" = "capture" ]; then
    cp $TMP/err $CASE/err.expected
    cp $TMP/warn $CASE/warn.expected
else
    if ! diff $CASE/err.expected $TMP/err >$TMP/err_diff ; then
       FAILED=1
       echo "${NAME}: compile error output differs"
       cat $TMP/err_diff
       cp $TMP/err $CASE/err.test
       cp $TMP/err_diff $CASE/err.diff
    fi

    if ! diff $CASE/warn.expected $TMP/warn >$TMP/warn_diff ; then
       FAILED=1
       echo "${NAME}: compile warn output differs"
       cat $TMP/warn_diff
       cp $TMP/warn $CASE/warn.test
       cp $TMP/warn_diff $CASE/warn.diff
    fi
fi  

if [ -f ./${BINARY} ] ; then
    if [ -f $CASE/fail.expected ] ; then   
        echo "${NAME}: expected compile failure but binary present ${BINARY}"
        exit 1
    fi

    ./${BINARY} 2>&1 | cat >$TMP/out

    if [ -z "$QUIET" ] ; then
        cat $TMP/out
    fi
elif [ -f $CASE/fail.expected ] ; then

    if [ "$2" = "capture" ]; then
        echo "${NAME}: captured errors:"
        cat $CASE/err.expected

        echo "${NAME}: captured warnings:"
        cat $CASE/warn.expected
    fi
    
    exit $FAILED
else
    echo "${NAME}: expected compile success but no binary present ${BINARY}"
    exit 1
fi

if [ "$2" = "capture" ]; then
    cp $TMP/out $CASE/out.expected

    echo "${NAME}: captured output:"
    cat $CASE/out.expected

    echo "${NAME}: captured errors:"
    cat $CASE/err.expected

    echo "${NAME}: captured warnings:"
    cat $CASE/warn.expected
else
    if ! diff $CASE/out.expected $TMP/out >$TMP/out_diff ; then
       FAILED=1
       echo "${NAME}: test output differs"
       cat $TMP/out_diff       
       cp $TMP/out $CASE/out.test
       cp $TMP/out_diff $CASE/out.diff
    fi
fi

exit $FAILED

