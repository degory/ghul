#!/usr/bin/env bash
#
# library-tag.sh - print the release of a source library that ghul-cli
# would build with the compiler in this checkout: the newest tag at or above
# the floor build/requirements.json names for it, whose own
# requirements.json names a minimum compiler no newer than <compiler>. A
# release from before that file existed builds with any compiler, and a
# compiler that is not a release is taken to be newer than any floor.
#
# Usage: build/library-tag.sh <library> <compiler-version>
#
# <library> is ghul-core or ghul-runtime, and is fetched from
# github.com/ghul-lang/<library>.

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: build/library-tag.sh <library> <compiler-version>" >&2
    exit 2
fi

library="$1"
compiler="$2"
here="$(cd "$(dirname "$0")" && pwd)"
url="https://github.com/ghul-lang/$library"

floor="$(sed -n "s/.*\"$library\": *\"\\([^\"]*\\)\".*/\\1/p" "$here/requirements.json")"

if [ -z "$floor" ]; then
    echo "build/requirements.json names no floor for $library" >&2
    exit 1
fi

# true where version $1 is at or above version $2
at_least() {
    [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

tags="$(git ls-remote --tags --refs "$url" | sed -n 's|.*refs/tags/v\([0-9][0-9.]*\)$|\1|p' | sort -rV)"

for version in $tags; do
    if ! at_least "$version" "$floor"; then
        break
    fi

    needs="$(curl -fsSL "https://raw.githubusercontent.com/ghul-lang/$library/v$version/requirements.json" 2>/dev/null \
        | sed -n 's/.*"minimum-compiler": *"\([^"]*\)".*/\1/p' || true)"

    if [ -z "$needs" ] || [[ "$compiler" == *-* ]] || at_least "$compiler" "$needs"; then
        echo "v$version"
        exit 0
    fi
done

echo "no release of $library from v$floor builds with ghul.compiler $compiler" >&2
exit 1
