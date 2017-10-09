$workspace=(pwd).path
docker volume create lcache
docker run -v lcache:/tmp/lcache -v ${workspace}:/home/dev/source/ -w /home/dev/source -it ghul/compiler:stable /bin/bash

