#!/bin/bash

export MSYS_NO_PATHCONV=1

if [ -z $1 ] ; then
    echo "usage: ./dev-capture.sh test-case-name"
    exit 1
fi

CASE=`echo test/cases/$1*`

if [ -d $DIRECTORY ] ; then
    ARGUMENT=`basename $CASE`
else
    ARGUMENT=$1
fi

#!/bin/bash
docker run -v `pwd`:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` -t ghul/compiler:stable ./capture.sh $ARGUMENT
