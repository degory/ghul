#!/bin/bash

ROOT=${1}

if [ -z "${ROOT}" ] ; then
    ROOT=`pwd`
fi

echo root is ${ROOT}

read -p "new test name (use-kebab-case): " TEST_NAME

if [ -z "${TEST_NAME}" ] ; then
    echo "no test name given"
    exit 1
fi

if [ ! -d ${ROOT}/test/cases ] ; then
    echo "expected to find test/cases folder under ${ROOT}"
    exit 1
fi

cp -r test/template ${ROOT}/test/cases/${TEST_NAME}

code ${ROOT}/test/cases/${TEST_NAME}