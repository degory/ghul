#!/bin/bash
pushd docker
./pull-all.sh latest
popd
docker run -e GHUL=/usr/bin/ghul -v $WORKSPACE:/home/dev/source -w /home/dev/source -u `id -u`:`id -g` -t docker.giantblob.com/ghul-ci ./bootstrap.sh
