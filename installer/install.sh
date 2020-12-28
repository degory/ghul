#!/bin/bash

PATH=/sbin:/usr/sbin:$PATH

function install_packages_dotnet {
    echo -n "installing packages"

    if ! mkdir -p project/packages >log.txt 2>&1 ; then
        echo ; echo "❌ temporary project folder creation failed"
        return 1
    fi

    echo -n "."

    pushd project >/dev/null

    if ! dotnet new console -verbosity:q >>log.txt 2>&1 ; then
        echo ; echo "❌ dummy .NET project creation failed"
        cat log.txt ; popd >/dev/null ; FAILED=1 ; return
    fi

    echo -n "."

    if ! dotnet add package --package-directory packages runtime.linux-x64.Microsoft.NETCore.ILAsm >>log.txt 2>&1 ; then
        echo ; echo "❌ ILAsm package install failed"
        cat log.txt ; popd >/dev/null ; FAILED=1 ; return
    fi

    echo -n "."

    if ! dotnet add package --package-directory packages ghul.runtime >>log.txt 2>&1 ; then
        echo ; echo "❌ ghūl runtme package install failed"
        cat log.txt ; popd >/dev/null ; FAILED=1 ; return
    fi

    echo "."

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

    if ! chmod 755 usr/lib/ghul/dotnet/ghul-runtime.dll ; then
        echo "❌ could not set executable permission on downloaded 'ghul-runtime.dll'"
        return 1;
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
    if ! ${PREFIX} rm -rf /usr/lib/ghul ; then
        FAILED=1
    else
        for f in /usr/bin/ghul /usr/bin/ghul.exe /usr/bin/ghul.runtimeconfig.json /usr/bin/ghul-test /usr/bin/ghul-test.exe /usr/bin/ghul-test.runtimeconfig.json ; do
            if [ -f "${f}" ] ; then
                if ! ${PREFIX} rm -f ${f} ; then
                    FAILED=1
  
                    break
                fi
            fi
        done
    fi

    if [ ! ${FAILED} ] ; then
        echo "✔️ existing ghūl installation removed"
    else
        echo "❌ failed to remove existing ghūl installation"
        exit 1
    fi
fi

umask 0022

if ${PREFIX} cp -r ./usr/* /usr ; then
    echo "✔️ copied files to /usr"
else
    echo "❌ failed files to /usr"
    exit 1
fi

# cp -a hoses permissions on the development container, so need to set executable permissions on copied manually:
for f in `find ./usr -type f -executable` ; do
    if ! ${PREFIX} chmod +x ${f:1} ; then
        echo "❌ failed set executable permission on ${f:1}"
    fi
done

echo "✔️ set executable permission on binaries and scripts"

echo -n "✔️ ghūl compiler installed: "

/usr/bin/ghul

if [ $EUID != 0 ] ; then
    if [ -x "`command -v id`" ]; then
        $PREFIX chown -R `id -u`:`id -g` ./usr
    else
        echo "❌ unable to chown \"`pwd`/usr\": you may need to manually delete it"
    fi
fi