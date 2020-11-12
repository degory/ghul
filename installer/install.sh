#!/bin/bash

PATH=/sbin:/usr/sbin:$PATH

if ldconfig -p | fgrep -q libgc.so.1 ; then echo
    echo "✔️ libgc found"
else
    echo "❌ libgc.so.1 not found: please install the Boehm GC development package (e.g. apt install libgc1c2)"
    FAILED=1
fi

if [ "$1" != "-L" ] && [ "$1" != "-D" ] ; then
    if [ -x "`which ilasm`" ] ; then
        echo "✔️ ilasm found"
    else
        echo "❌ ilasm not found: please install the Mono development package (e.g. apt install mono-devel)"
        FAILED=1
    fi
else
    echo "✔️ legacy only install: ilasm not needed"
fi

if [ "$1" == "-L" ] || [ "$1" == "-A" ] ; then
    if [ -x "`which docker`" ] ; then
        echo "✔️ docker found"
    else
        echo "❌ docker not found: please install"
        FAILED=1
    fi
elif [ "$1" == "-D" ] ; then
    echo "✔️ legacy container install: docker not needed"
else
    echo "✔️ dotnet only install: docker not needed"
fi

if [ $FAILED ] ; then
    echo "❌ prerequisites check failed: please correct and retry"
    exit 1
fi

if [ $EUID == 0 ] ; then
    echo "✔️ you are root: sudo not required"
    PREFIX="";
elif [ -x "`which sudo`" ] ; then
    echo "✔️ you are not root, but sudo found: please enter your password if prompted"
    PREFIX="sudo"
else
    echo "❌ you are not root and sudo not found on the path: giving up"
    exit 1
fi

if [ -d /usr/lib/ghul ] ; then
    if $PREFIX rm -r /usr/lib/ghul /usr/bin/ghul /usr/bin/ghul.exe ; then
        echo "✔️ existing ghūl installation removed"
    else
        echo "❌ failed to remove existing ghūl installation: please manually delete /usr/lib/ghul/"
        exit 1
    fi
fi

if [ "$1" == "-L" ] || [ "$1" == "-A" ] ; then
    if [ -x "`which docker`" ] ; then
        if docker pull --quiet ghul/compiler:stable ; then
            echo "✔️ pulled latest ghul compiler container"
        else
            echo "❌ failed to pull the latest docker container"
        fi
    else
        echo "docker not found: legacy target will not be supported"
    fi
fi

if [ "$1" != "-L" ] && [ "$1" != "-D" ] && [ -f usr/bin/ghul.exe ] ; then
    if mono --aot=full -O=all usr/bin/ghul.exe >aot-log.txt 2>&1 ; then
        echo "✔️ ghūl compiler AOT compile succeeded"
    else
        cat aot-log.txt
        echo "❌ ghūl compiler AOT compile failed"
    fi
fi

if umask 0022 && $PREFIX chown -R root:root ./usr && $PREFIX cp -a usr / ; then
    if [ "$1" == "-A" ] ; then
        TARGET=".NET and legacy targets"
    elif [ "$1" == "-L" ] || [ "$1" == "-D" ] ; then
        TARGET="legacy target"
    else
        TARGET=".NET target"
    fi

    echo "✔️ ghūl compiler installed for $TARGET"
else
    echo "❌ installation failed"
    exit 1
fi

echo

echo -n "legacy compiler version: "
/usr/bin/ghul

if [ "$1" != "-L" ] && [ "$1" != "-D" ] && [ -f /usr/bin/ghul.sh ] ; then
    echo -n ".NET hosted compiler version: "
    /usr/bin/ghul.sh
fi

if [ -x "`which id`" ] ; then
    $PREFIX chown -R `id -u`:`id -g` ./usr
else
    echo "unable to chown \"`pwd`/usr\": you may need to manually delete it"
fi