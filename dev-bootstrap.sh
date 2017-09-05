#!/bin/bash
mkdir -p /tmp/lcache-dev 2>&1 >/dev/null
docker run -e LFLAGS="-FB -FN" -e GHUL=/usr/bin/ghul -e JOB_NAME=dev -v $WORKSPACE:/home/dev/source -w /home/dev/source -u `id -u`:`id -g` -t docker.giantblob.com/ghul-dev ./bootstrap.sh
