#!/bin/bash

ROOT=${1}

if [ -z "${ROOT}" ] ; then
    ROOT=`pwd`
fi

echo root is ${ROOT}

read -p "new test name (folder/kebab-case-test-name): " TEST_NAME

if [ -z "${TEST_NAME}" ] ; then
    echo "no test name given"
    exit 1
fi

if [ ! -d ${ROOT}/integration-tests ] ; then
    echo "expected to find integration-tests folder under ${ROOT}"
    exit 1
fi

cp -r ${ROOT}/integration-tests/template ${ROOT}/integration-tests/${TEST_NAME}

code ${ROOT}/integration-tests/${TEST_NAME}