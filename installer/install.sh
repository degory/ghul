#!/bin/bash

PATH=/sbin:/usr/sbin:$PATH

if [ -x "`command -v nuget`" ] && nuget install runtime.linux-x64.Microsoft.NETCore.ILAsm -verbosity quiet -outputdirectory ilasm ; then
    mkdir -p usr/lib/ghul/ilasm
    cp `find ilasm -type f -name ilasm` usr/lib/ghul/ilasm
    chmod 755 usr/lib/ghul/ilasm usr/lib/ghul/ilasm/ilasm

    echo "✔️ .NET Core ilasm downloaded via NuGet"
elif curl https://share.giantblob.com:5001/sharing/uU4aDcpEk -o ilasm ; then
    mkdir -p usr/lib/ghul/ilasm
    cp ilasm usr/lib/ghul/ilasm
    chmod 755 usr/lib/ghul/ilasm usr/lib/ghul/ilasm/ilasm

    echo "✔️ .NET Core ilasm downloaded giantblob.com"
elif [ -x /usr/bin/ilasm ] ; then
    echo "✔️ ilasm found in /usr/bin"
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
elif [ -x "`command -v sudo`" ] ; then
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

mono /usr/bin/ghul.exe

if [ $EUID != 0 ] ; then
    if [ -x "`command -v id`" ]; then
        $PREFIX chown -R `id -u`:`id -g` ./usr
    else
        echo "unable to chown \"`pwd`/usr\": you may need to manually delete it"
    fi
fi