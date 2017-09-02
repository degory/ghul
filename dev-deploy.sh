#!/bin/bash
cd docker
cp ../ghul/ghul ghul-ci
cp ../ghul/ghul ghul-dev
./build-all.sh
