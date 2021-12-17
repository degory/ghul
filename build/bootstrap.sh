#!/bin/bash
set -e

if [ -z "${TAG_VERSION}" ] ; then
    TAG_VERSION=v0.0.0
fi

VALID_VERSION_REGEX="^v[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9]+\.[0-9]+)?$"

if [[ ! ${TAG_VERSION} =~ ${VALID_VERSION_REGEX} ]] ; then
    echo "invalid tag version number: ${TAG_VERSION}"
    exit 1
fi

if [ -z "${PACKAGE_VERSION}" ] ; then
    PACKAGE_VERSION="${TAG_VERSION:1}"
fi

echo "Bootstrapping tag version ${TAG_VERSION} to produce package version ${PACKAGE_VERSION}"

VALID_VERSION_PREFIX_REGEX="^([0-9]+\.[0-9]+\.[0-9]+)"

if [[ ${PACKAGE_VERSION} =~ ${VALID_VERSION_PREFIX_REGEX} ]] ; then

    VERSION_PREFIX=${BASH_REMATCH[1]}

    echo ${VERSION_PREFIX}
else
    exit 1
fi

if [ "${CI}" == "" ] ; then
    LOCAL=true

    cleanup() {
        echo "Cleaning up..."
        dotnet tool uninstall --local ghul.compiler
        dotnet tool install --local ghul.compiler
    }

    trap cleanup EXIT
fi

VERBOSITY="-verbosity:quiet"

for PASS in 1 2 3 4 ; do
    PREVIOUS=$(dotnet ghul-compiler)

    if [[ "${LOCAL}" == "" &&  ( "${PASS}" == "3" || "${PASS}" == "4" ) ]] ; then
        VERSION="${PACKAGE_VERSION}"
    else
        VERSION="${VERSION_PREFIX}-bootstrap.$(($(date +%s%N)/1000))"
    fi

    echo
    echo "    Start pass ${PASS}: ${PREVIOUS} -> ${VERSION}..."

    rm -rf nupkg ; mkdir nupkg

    dotnet pack -nologo ${VERBOSITY} -p:CI=true -p:Version=${VERSION} -consoleloggerparameters:NoSummary

    echo "   Packed pass ${PASS}: ${PREVIOUS} -> ${VERSION}"
    echo

    dotnet tool uninstall --local ghul.compiler # >/dev/null 2>&1
    dotnet tool install --local ghul.compiler --add-source nupkg --version ${VERSION} # >/dev/null 2>&1

    echo
    echo "Installed pass ${PASS}: ${PREVIOUS} -> ${VERSION}"

    dotnet ghul-compiler

    if [ "${PASS}" != "1" ] && [ "${PASS}" != "2" ] ; then
        mv out.il stage-${PASS}.il
    fi

    dotnet clean -nologo -verbosity:quiet

    echo
    echo " Finished pass ${PASS}: ${PREVIOUS} -> ${VERSION}"
done

echo
echo "Verify IL matches for last two passes..."

# there should be no differences between pass 3 IL and pass 4 IL except
# for the version info, which is in a custom attribute ('.custom : ....')
diff \
    <(grep -v "^\.custom instance void \[System.Runtime\]System.Reflection\.AssemblyInformationalVersionAttribute" stage-3.il) \
    <(grep -v "^\.custom instance void \[System.Runtime\]System.Reflection\.AssemblyInformationalVersionAttribute" stage-4.il)

echo
echo "Successfully Bootstrapped `dotnet ghul-compiler`"

