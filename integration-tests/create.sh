#!/bin/bash

ROOT="$1"
TEST_NAME="$2"

if [ -z "${ROOT}" ] ; then
    ROOT="`pwd`"
fi

echo will create test under "${ROOT}/integration-tests"

if [ -z "${TEST_NAME}" ] ; then
    read -p "new test name (folder/kebab-case-test-name): " TEST_NAME
fi

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