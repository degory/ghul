#!/bin/bash

docker run --name "typecheck-`date +'%s'`" --rm \
    -v `pwd`:/usr/local/bin \
    -v `pwd`:/home/dev/source/ \
    -v `pwd`/lib:/usr/lib/ghul \
    -w /home/dev/source/ \
    -u `id -u`:`id -g` \
    ghul/mono-base \
    bash -c "find src -name '*.ghul' | xargs ./ghul -G /usr/lib/ghul/ghul.ghul" 
