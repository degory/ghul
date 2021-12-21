#!/bin/bash
FROM=$1

if [ "${FROM}" == "" ] ; then
    FROM=$(dirname "$0")/..
fi

dotnet tool uninstall ghul.compiler >/dev/null 2>&1
OUTPUT=$(dotnet tool install ghul.compiler --version $(${FROM}/build/get-version-number.sh ${FROM}/Directory.Build.props) --add-source $FROM/nupkg 2>&1)

if [ "$?" != "0" ] ; then
    echo $OUTPUT
    exit 1
else
    dotnet ghul-compiler
fi