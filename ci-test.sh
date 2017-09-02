#!/bin/bash
docker run -v /var/lib/jenkins/workspace/:/var/lib/jenkins/workspace/ -w $WORKSPACE --user jenkins -t docker.giantblob.com/ghul-ci /bin/bash -c "./test.sh"

