#!/bin/bash

PATH=/sbin:/usr/sbin:$PATH

if [ -x "`which ilasm`" ] ; then
    echo "✔️ ilasm found"
else
    echo "❌ ilasm not found: please install the Mono development package (e.g. apt install mono-devel)"
    FAILED=1
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
    TO_DELETE=/usr/lib/ghul

    for f in /usr/bin/ghul /usr/bin/ghul.exe /usr/bin/ghul.sh ; do
        if [ -f "$f" ] ; then
            TO_DELETE="$TO_DELETE $f"
        fi
    done
fi

if [ ! -z "$TO_DELETE" ] ; then
    if $PREFIX rm -r $TO_DELETE ; then
        echo "✔️ existing ghūl installation removed"
    else
        echo "❌ failed to remove existing ghūl installation: please manually delete $TO_DELETE"
        exit 1
    fi
fi

if mono --aot=full -O=all usr/bin/ghul.exe >aot-log.txt 2>&1 ; then
    echo "✔️ ghūl compiler AOT compile succeeded"
else
    cat aot-log.txt
    echo "❌ ghūl compiler AOT compile failed"
fi

if umask 0022 && $PREFIX chown -R root:root ./usr && $PREFIX cp -a usr / ; then
    echo "✔️ ghūl compiler installed"
else
    echo "❌ installation failed"
    exit 1
fi

echo
echo -n "Compiler version: "
/usr/bin/ghul

if [ -x "`which id`" ] ; then
    $PREFIX chown -R `id -u`:`id -g` ./usr
else
    echo "unable to chown \"`pwd`/usr\": you may need to manually delete it"
fi