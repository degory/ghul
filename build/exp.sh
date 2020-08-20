#!/bin/bash

echo "namespace Source is class BUILD is number: System.String static => \"local-`date +'%s'`\"; si si" >src/source/build.ghul

docker run --name "typecheck-`date +'%s'`" --rm \
    -v `pwd`:/usr/local/bin \
    -v `pwd`:/home/dev/source/ \
    -v `pwd`/lib:/usr/lib/ghul \
    -w /home/dev/source/ \
    -u `id -u`:`id -g` \
    ghul/mono-base \
    bash -c "find src -name '*.ghul' | xargs ./ghul -G -X ./lib/ghul.ghul" 
