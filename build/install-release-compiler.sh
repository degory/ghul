#!/bin/bash
COMPILER=$(dotnet ghul-compiler 2>/dev/null)
ALPHA_REGEX="v[0-9]+\.[0-9]+\.[0-9]+-[A-Za-z]+\.[0-9]+"

if [[ ${COMPILER} =~ ${ALPHA_REGEX} ]] ; then
    echo "removing ${COMPILER}..."
    dotnet tool uninstall ghul.compiler

    COMPILER=""
fi

if [ "${COMPILER}" == "" ] ; then
    echo "installing release compiler..."
    dotnet tool install ghul.compiler
fi

echo "compiler now $(dotnet ghul-compiler)"
