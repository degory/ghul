#!/bin/bash
mkdir -p /tmp/lcache-dev 2>&1 >/dev/null
echo "namespace Source is class BUILD is public static System.String number=\"local\"; si si" >source/build.l
docker run -e LFLAGS="-FB -FN" -e JOB_NAME=dev -v /tmp/lcache-dev:/tmp/lcache-dev -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -t docker.giantblob.com/ghul:stable ./convert.sh
