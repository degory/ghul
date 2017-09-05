#!/bin/bash
pushd docker
./pull-all.sh latest
popd
docker run -v /var/lib/jenkins/workspace/:/var/lib/jenkins/workspace/ -w $WORKSPACE --user jenkins -t docker.giantblob.com/ghul-ci /bin/bash -c "./clean.sh && ./build.sh"

