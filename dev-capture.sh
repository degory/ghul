#!/bin/bash
docker run -v `pwd`:/home/dev/source/ -w /home/dev/source --user dev -t docker.giantblob.com/dev /bin/bash -c "./capture.sh"


