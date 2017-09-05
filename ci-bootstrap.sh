#!/bin/bash
pushd docker
./pull-all.sh
popd
docker run -v /var/lib/jenkins/workspace/:/var/lib/jenkins/workspace/ -w $WORKSPACE --user jenkins -t docker.giantblob.com/ghul-ci ./bootstrap.sh
