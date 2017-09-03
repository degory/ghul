#!/bin/bash
FILE=$1
if [[ ${FILE: -5} = ".ghul" ]] ; then
    CASE=`dirname $FILE`
    NAME=`basename $CASE`

    echo "Explicit case given $CASE $NAME"

    docker run -e GHULFLAGS -v `pwd`:/home/dev/source/ -w /home/dev/source --user dev -t docker.giantblob.com/dev /bin/bash -c "./test.sh $NAME"
else
    docker run -e GHULFLAGS -v `pwd`:/home/dev/source/ -w /home/dev/source --user dev -t docker.giantblob.com/dev /bin/bash -c "./test.sh $1"
fi



