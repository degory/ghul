#!/bin/bash
cd $WORKSPACE/docker
cp ../ghul ghul-ci && \
cp ../ghul ghul-dev && \
./build-all.sh
