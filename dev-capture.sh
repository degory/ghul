#!/bin/bash
docker run -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -t docker.giantblob.com/ghul-dev ./capture.sh $1


