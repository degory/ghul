#!/bin/bash

find src ../src/system -name '*.ghul' | xargs mono /usr/bin/ghul.exe -p ../lib -o ghul-test.exe