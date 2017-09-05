#!/bin/bash
if [ -z "$JOB_NAME" ]; then
    export JOB_NAME=rewrite-ci
fi

if [ -d /tmp/lcache-$JOB_NAME ]; then
    rm -rf /tmp/lcache-$JOB_NAME/*
fi
