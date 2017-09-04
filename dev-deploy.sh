#!/bin/bash
cd docker
cp ../ghul ghul-ci && \
cp ../ghul ghul-dev && \
./build-all.sh
