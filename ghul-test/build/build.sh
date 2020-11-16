#!/bin/bash

find src ../src/system -name '*.ghul' | xargs /usr/bin/ghul -p ../lib -o ghul-test.exe