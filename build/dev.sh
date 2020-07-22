#!/bin/bash

MSYS_NO_PATHCONV=1 \
docker run --name "dev-`date +'%s'`" --rm -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -it ghul/compiler:stable /bin/bash
