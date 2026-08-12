#!/bin/bash
set -e

START_MILLISECONDS=$(date +%s%N)

if [ "${CI}" == "" ] ; then
    LOCAL=true

    PRE_BOOTSTRAP_VERSION=$(dotnet tool list --local 2>/dev/null | awk '$1 == "ghul.compiler" { print $2 }')

    cleanup() {
        echo "Cleaning up..."
        dotnet tool uninstall --local ghul.compiler >/dev/null 2>&1 || true
        if [ -n "${PRE_BOOTSTRAP_VERSION}" ] ; then
            dotnet tool install --local ghul.compiler --version "${PRE_BOOTSTRAP_VERSION}"
        else
            dotnet tool install --local ghul.compiler
        fi
    }

    trap cleanup EXIT
fi

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


VERBOSITY="-verbosity:quiet"

for PASS in 1 2 3 4 ; do
    PREVIOUS=$(dotnet ghul-compiler)

    # Every pass builds an assembly stamped with the same version, so
    # that the last two differ only where the compiler differs. Only the
    # package version varies: two different builds published under one
    # package version would be served from the NuGet cache as whichever
    # arrived first, and the second pass would silently re-test the
    # first.
    # The last pass's package is the build's output, so it carries the
    # real package version; the earlier ones only have to be distinct
    # from each other.
    if [ "${PASS}" == "4" ] ; then
        PASS_PACKAGE_VERSION="${PACKAGE_VERSION}"
    else
        PASS_PACKAGE_VERSION="${VERSION_PREFIX}-bootstrap.$(($(date +%s%N)/1000))"
    fi

    echo
    echo "    Start pass ${PASS}: ${PREVIOUS} -> ${PACKAGE_VERSION} (package ${PASS_PACKAGE_VERSION})..."

    rm -rf nupkg ; mkdir nupkg

    dotnet pack -nologo ${VERBOSITY} -p:CI=true -p:Version=${PACKAGE_VERSION} -p:PackageVersion=${PASS_PACKAGE_VERSION} -consoleloggerparameters:NoSummary

    echo "   Packed pass ${PASS}"
    echo

    dotnet tool uninstall --local ghul.compiler >/dev/null 2>&1 || true

    dotnet tool install --local ghul.compiler --add-source nupkg --version ${PASS_PACKAGE_VERSION}

    echo
    echo "Installed pass ${PASS}"

    dotnet ghul-compiler

    if [ "${PASS}" == "3" ] || [ "${PASS}" == "4" ] ; then
        cp bin/Release/net10.0/ghul.dll stage-${PASS}.dll
    fi

    dotnet clean -nologo -verbosity:quiet

    echo
    echo " Finished pass ${PASS}"
done

echo
echo "Verify the last two passes emitted the same assembly..."

# A compiler that reproduces itself emits the same bytes, not merely an
# equivalent program. That is only a fair test because emission is
# deterministic - the module version id is a hash of the content and the
# PE stamp comes from the same hash, so nothing carries the clock.
if ! cmp stage-3.dll stage-4.dll ; then
    echo
    echo "pass 3 and pass 4 differ - the compiler does not reproduce itself"
    exit 1
fi

echo "identical"

echo

END_MILLISECONDS=$(date +%s%N)

ELAPSED_SECONDS=$(awk -v start="$START_MILLISECONDS" -v end="$END_MILLISECONDS" 'BEGIN { printf "%.2f", (end - start) / 1000000000 }')

echo "Successfully Bootstrapped $(dotnet ghul-compiler) in ${ELAPSED_SECONDS} seconds"
