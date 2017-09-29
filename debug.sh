#!/bin/bash
docker run --privileged -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -it ghul/compiler:stable /bin/bash
