#!/bin/bash
docker run -e GHULFLAGS -v `pwd`:/home/dev/source/ -w /home/dev/source --user dev -t docker.giantblob.com/dev /bin/bash -c "./test.sh $1"


