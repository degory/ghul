#!/bin/bash

PATH=/sbin:/usr/sbin:$PATH

function install_packages_dotnet {
    if ! mkdir -p project/packages >/dev/null ; then
        echo "❌ temporary project folder creation failed"
        return 1
    fi

    pushd project >/dev/null

    if ! dotnet new console -verbosity:q >/dev/null ; then
        echo "❌ dummy .NET project creation failed"
        popd ; FAILED=1 ; return
    fi

    if ! dotnet add package --package-directory packages runtime.linux-x64.Microsoft.NETCore.ILAsm >/dev/null ; then
        echo "❌ ILAsm package install failed"
        popd ; FAILED=1 ; return
    fi

    if ! dotnet add package --package-directory packages ghul.runtime >/dev/null ; then
        echo "❌ ghūl runtme package install failed"
        popd ; FAILED=1 ; return
    fi

    popd >/dev/null

    ILASM=`find project/packages -type f -name ilasm`

    if [ -z "$ILASM" ] ; then
        echo "❌ could not find downloaded 'ilasm'"
        FAILED=1 ; return
    fi

    if ! cp $ILASM usr/lib/ghul/ilasm ; then
        echo "❌ could not copy downloaded 'ilasm' into install source directory"
        FAILED=1 ; return
    fi

    if ! chmod 755 usr/lib/ghul/ilasm usr/lib/ghul/ilasm/ilasm ; then
        echo "❌ could not set executable permission on downloaded 'ilasm'"
        return 1;
    fi

    echo "✔️ .NET ILAsm downloaded via dotnet package add"

    RUNTIME=`find project/packages -type f -name ghul-runtime.dll`

    if [ -z "$RUNTIME" ] ; then
        echo "❌ could not find downloaded 'ghul-runtime.dll'"
        FAILED=1 ; return
    fi

    if ! cp $RUNTIME usr/lib/ghul/dotnet ; then
        echo "❌ could not copy downloaded 'ghul-runtime.dll' into install source directory"
        FAILED=1 ; return
    fi

    echo "✔️ ghūl runtme downloaded via dotnet package add"
}

function install_packages_nuget {
    if ! nuget install runtime.linux-x64.Microsoft.NETCore.ILAsm -verbosity quiet -outputdirectory ilasm ; then
        echo "❌ ILAsm package install failed"
        FAILED=1 ; return
    fi

    if ! mkdir -p usr/lib/ghul/ilasm ; then
        echo "❌ could not create ilasm folder"
        FAILED=1 ; return
    fi

    ILASM=`find ilasm -type f -name ilasm`

    if [ -z "$ILASM" ] ; then
        echo "❌ could not find downloaded 'ilasm'"
        FAILED=1 ; return
    fi

    if ! cp $ILASM usr/lib/ghul/ilasm ; then
        echo "❌ could not copy downloaded 'ilasm' into install source directory"
        FAILED=1 ; return
    fi

    echo "✔️ .NET Core ilasm downloaded via NuGet"

    return 0
}

function install_packages_curl {
    if ! curl https://degory.github.io/ilasm -o ilasm ; then
        echo "❌ could not download ILAsm via curl"
        FAILED=1 ; return
    fi

    if ! mkdir -p usr/lib/ghul/ilasm ; then
        echo "❌ could not create ilasm folder"
        FAILED=1 ; return
    fi

    if ! cp ilasm usr/lib/ghul/ilasm ; then
        echo "❌ could not copy downloaded 'ilasm' into install source directory"
        FAILED=1 ; return
    fi

    if ! chmod 755 usr/lib/ghul/ilasm usr/lib/ghul/ilasm/ilasm ; then
        echo "❌ could not set executable permission on downloaded 'ilasm'"
        FAILED=1 ; return
    fi

    echo "✔️ .NET Core ilasm downloaded from GitHub"
}

if [ -x "`command -v dotnet`" ] ; then
    echo "✔️ .NET found"

    install_packages_dotnet
elif [ -x "`command -v mono`" ] ; then
    echo "✔️ Mono found"

    if [ -x "`comand -v nuget`" ] ; then
        echo "✔️ NuGet found"

        install_packages_nuget
    elif [ -x "`comand -v curl`" ] ; then
        echo "✔️ curl found"
        install_packages_curl
    elif [ -x /usr/bin/ilasm ] ; then
        echo "✔️ ilasm found in /usr/bin"
    else
        echo "❌ neither NuGet nor curl found: cannot download packages"
        FAILED=1
    fi
else
    echo "❌ no CLR found: please install either .NET 5.0 or Mono 6"
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

if umask 0022 && $PREFIX chown -R root:root ./usr && $PREFIX cp -a usr / ; then
    echo "✔️ ghūl compiler installed"
else
    echo "❌ installation failed"
    exit 1
fi

echo
echo -n "Compiler version: "

/usr/bin/ghul

if [ $EUID != 0 ] ; then
    if [ -x "`command -v id`" ]; then
        $PREFIX chown -R `id -u`:`id -g` ./usr
    else
        echo "unable to chown \"`pwd`/usr\": you may need to manually delete it"
    fi
fi