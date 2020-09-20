#!/bin/bash

if ldconfig -p | fgrep -q libgc.so.1 ; then echo
    echo "✅ libgc found"
else
    echo "❌ libgc.so.1 not found: please install libgc1c2 (e.g. apt install libgc1c2)"
    FAILED=1
fi

if [ "$1" == "-L" ] ; then
    if [ -x "`which docker`" ] ; then
        echo "✅ docker found"
    else
        echo "❌ legacy only install requested but docker not found: please install"
    fi
else
    if [ -x "`which ilasm`" ] ; then
        echo "✅ ilasm found"
    else
        echo "❌ ilasm not found: please install mono SDK (https://www.mono-project.com/download/stable/)"
        FAILED=1
    fi
fi

if [ $FAILED ]; then
    echo "❌ prerequisites check failed: please correct and retry"
    exit 1
fi

if [ `id -u` == 0 ] ; then
    echo "✅ you are root: sudo not required"
    PREFIX="";

elif [ -x "`which sudo`" ] ; then
    echo "✅ you are not root, but sudo found: please enter your password if prompted"
    PREFIX="sudo"
else
    echo "❌ you are not root and sudo not found on the path: giving up"
    exit 1
fi

if [ -d /usr/lib/ghul ] ; then
    if $PREFIX rm -r /usr/lib/ghul /usr/bin/ghul ; then
        echo "✅ existing ghūl installation removed"
    else
        echo "❌ failed to remove existing ghūl installation: please manually delete /usr/lib/ghul/"
        exit 1
    fi
fi

if [ -x "`which docker`" ] ; then
    if docker pull --quiet ghul/compiler:stable ; then
        echo "✅ pulled latest ghul compiler container"
    else
        echo "❌ failed to pull the latest docker container"
    fi
else
    echo "docker not found: legacy target will not be supported"
fi

if $PREFIX cp -r usr / ; then
    echo "✅ ghūl compiler installed"
else
    echo "❌ failed to copy files"
    exit 1
fi

/usr/bin/ghul
