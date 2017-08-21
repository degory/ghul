FAILED=0
NAME=$1
CASE=cases/$NAME

if [ "$TMP" = "" ] ; then
    TMP=tmp
fi

if [ -f $CASE/ghulflags ] ; then
    GHULFLAGS="$GHULFLAGS `cat $CASE/ghulflags`"
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

echo "${NAME}: compile ${CASE}/test.l as ${BINARY}..."
echo $GHUL $GHULFLAGS $CASE/*.ghul 2>$TMP/err_out
$GHUL $GHULFLAGS $CASE/*.ghul 2>$TMP/err_out
# mv test $CASE
grep error: $TMP/err_out | sort >$TMP/err
grep warn: $TMP/err_out | sort >$TMP/warn
if [ "$2" = "capture" ]; then
    cp $TMP/err $CASE/err
    cp $TMP/warn $CASE/warn
else
    if ! diff $CASE/err $TMP/err >$TMP/err_diff ; then
       FAILED=1
       echo "${NAME}: compile error output differs"
       # cat $TMP/err_diff
       cp $TMP/err $CASE/err.test
       cp $TMP/err_diff $CASE/err.diff
    fi

    if ! diff $CASE/warn $TMP/warn >$TMP/warn_diff ; then
       FAILED=1
       echo "${NAME}: compile warn output differs"
       # cat $TMP/warn_diff
       cp $TMP/warn $CASE/warn.test
       cp $TMP/warn_diff $CASE/warn.diff
    fi
fi  

if [ -f ./${BINARY} ] ; then
    ./${BINARY} 2>&1 | cat >$TMP/out
elif [ -f $CASE/expectfail ] ; then
    exit 1
else
    
    echo "${NAME}: compile failed to produce binary ${BINARY}"
    exit 1
fi

if [ "$2" = "capture" ]; then
    cp $TMP/out $CASE/out
else
    if ! diff $CASE/out $TMP/out >$TMP/out_diff ; then
       FAILED=1
       echo "${NAME}: test output differs"
       cp $TMP/out $CASE/out.test
       cp $TMP/out_diff $CASE/out.diff
    fi
fi

exit $FAILED

