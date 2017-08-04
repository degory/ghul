#!/bin/bash
docker run -v `pwd`:/home/dev/source/ -w /home/dev/source --user dev -it docker.giantblob.com/dev /bin/bash -c "./test.sh"


