#!/bin/bash


docker run --name "dev-`date +'%s'`" --rm -e LFLAGS="-FB -FN -Ws -WM" -v /tmp/lcache/ -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` ghul/compiler:stable /bin/sh ./_build.sh
