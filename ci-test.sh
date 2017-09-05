#!/bin/bash
docker run docker -v $WORKSPACE:/home/dev/source -w /home/dev/source -u `id -u`:`id -g` -t docker.giantblob.com/ghul-ci /bin/bash ./test.sh


