#!/bin/bash
mkdir -p /tmp/lcache-dev
docker run -e LFLAGS="-FB -FN" -e JOB_NAME=dev -v /tmp/lcache-dev:/tmp/lcache-dev -v `pwd`:/home/dev/source/ -w /home/dev/source --user dev -t docker.giantblob.com/dev ./build.sh
