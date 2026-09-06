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

# One pass: pack the source with the compiler currently installed, install
# what came out, and keep the assembly it produced.
#
# Every pass builds an assembly stamped with the same version, so that the
# ones we compare differ only where the compiler differs. Only the package
# version varies: two different builds published under one package version
# would be served from the NuGet cache as whichever arrived first, and a
# later pass would silently re-test the earlier one.
run_pass() {
    local pass=$1
    local pass_package_version=$2
    local previous

    previous=$(dotnet ghul-compiler)

    echo
    echo "    Start pass ${pass}: ${previous} -> ${PACKAGE_VERSION} (package ${pass_package_version})..."

    dotnet pack -nologo ${VERBOSITY} -p:CI=true -p:Version=${PACKAGE_VERSION} -p:PackageVersion=${pass_package_version} -consoleloggerparameters:NoSummary

    echo "   Packed pass ${pass}"
    echo

    dotnet tool uninstall --local ghul.compiler >/dev/null 2>&1 || true

    dotnet tool install --local ghul.compiler --add-source nupkg --version ${pass_package_version}

    echo
    echo "Installed pass ${pass}"

    dotnet ghul-compiler

    cp bin/Release/net10.0/ghul.dll stage-${pass}.dll

    dotnet clean -nologo -verbosity:quiet

    echo
    echo " Finished pass ${pass}"
}

bootstrap_package_version() {
    echo "${VERSION_PREFIX}-bootstrap.$(($(date +%s%N)/1000))"
}

# Pass 1 is emitted by the previous release, so its assembly is not a
# candidate for comparison whatever the compiler does. Pass 2 is the first
# emitted by this source, and pass 3 the first that can be compared with
# one.
#
# Pass 3's package is the build's output, so it carries the real package
# version. That holds even when the divergence check below has to run a
# fourth pass, because a fourth pass is only accepted when it emits the
# same assembly, which makes the pass 3 package's payload the converged
# compiler either way.
for PASS in 1 2 ; do
    rm -rf nupkg ; mkdir nupkg
    run_pass ${PASS} "$(bootstrap_package_version)"
done

rm -rf nupkg ; mkdir nupkg
run_pass 3 "${PACKAGE_VERSION}"

echo
echo "Compare the earliest comparable pair..."

# If pass 2 and pass 3 match, the pass 2 compiler is already a fixed point of
# compiling this source and every later pass reproduces it, so there is
# nothing a fourth pass could add.
if cmp -s stage-2.dll stage-3.dll ; then
    echo "pass 2 and pass 3 are identical - the compiler reproduces itself"
else
    # Reaching the fixed point a generation late is not by itself a defect.
    # It is what happens when this source fixes a code generation bug that
    # afflicts the compiler's own body: pass 1 carries the new logic in a
    # body the old compiler emitted, so it can emit differently from pass 2
    # while both are doing the same thing. Say so plainly and let a fourth
    # pass settle it.
    echo
    echo "NOTICE: pass 2 and pass 3 differ, so the compiler did not reach a"
    echo "NOTICE: fixed point in two passes. That is expected when this"
    echo "NOTICE: source changes what the compiler emits for itself, since"
    echo "NOTICE: pass 1 runs a body the previous release emitted. Running a"
    echo "NOTICE: fourth pass to confirm it settles."

    # Packed alongside pass 3 rather than over it: pass 3's package is the
    # build's output and has to survive.
    run_pass 4 "$(bootstrap_package_version)"

    echo
    echo "Verify the extra pass emitted the same assembly..."

    # A compiler that reproduces itself emits the same bytes, not merely an
    # equivalent program. That is only a fair test because emission is
    # deterministic - the module version id is a hash of the content and the
    # PE stamp comes from the same hash, so nothing carries the clock.
    if ! cmp stage-3.dll stage-4.dll ; then
        echo
        echo "pass 3 and pass 4 differ - the compiler does not reproduce itself"
        exit 1
    fi

    echo "pass 3 and pass 4 are identical - the compiler reproduces itself"
fi

echo

END_MILLISECONDS=$(date +%s%N)

ELAPSED_SECONDS=$(awk -v start="$START_MILLISECONDS" -v end="$END_MILLISECONDS" 'BEGIN { printf "%.2f", (end - start) / 1000000000 }')

echo "Successfully Bootstrapped $(dotnet ghul-compiler) in ${ELAPSED_SECONDS} seconds"
