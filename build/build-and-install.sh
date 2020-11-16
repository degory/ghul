#!/bin/bash
set -e
./build/build.sh
./build/make-installer.sh
bash installer/ghul.run
