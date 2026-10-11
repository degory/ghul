#!/usr/bin/env bash
#
# llvm-check.sh - hand every module of the matrix to LLVM's own tools.
#
# The suite pins text; this script asks whether LLVM accepts that text.
# It writes a throwaway test that dumps each module to a .ll file, runs
# it, then for every file runs llvm-as, opt's verifier, and llc to an
# object file, and removes the test again.
#
# The tools are looked for, in order: in $LLVM_BIN if it is set; on the
# PATH under their plain names; on the PATH with a -$LLVM_VERSION suffix,
# as Debian's packages install them; and in /usr/lib/llvm-$LLVM_VERSION/bin.
# LLVM_VERSION defaults to 23. Finding no tools is an error, since a run
# that checks nothing would otherwise pass.
#
# Usage: llvm/tests/llvm-check.sh [output-dir]
#        (default: a fresh directory under /tmp)
#
# Exits nonzero if a tool is missing, or if any module is rejected by any
# tool.

set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
out="${1:-$(mktemp -d /tmp/llvm-matrix.XXXXXX)}"
mkdir -p "$out"

version="${LLVM_VERSION:-23}"

find_tool() {
    local name="$1"

    if [ -n "${LLVM_BIN:-}" ]; then
        [ -x "$LLVM_BIN/$name" ] && { echo "$LLVM_BIN/$name"; return; }
        return 1
    fi

    command -v "$name" 2>/dev/null && return
    command -v "$name-$version" 2>/dev/null && return
    [ -x "/usr/lib/llvm-$version/bin/$name" ] && { echo "/usr/lib/llvm-$version/bin/$name"; return; }

    return 1
}

missing=0
for tool in llvm-as opt llc; do
    path="$(find_tool "$tool")" || {
        echo "llvm-check: $tool not found; install LLVM $version or set LLVM_BIN" >&2
        missing=1
        continue
    }
    declare "tool_${tool//-/_}=$path"
done
[ "$missing" -eq 0 ] || exit 1

echo "using $("$tool_llvm_as" --version | grep -i 'version' | head -1 | sed 's/^ *//') at $(dirname "$tool_llvm_as")"

dump="$here/_llvm_dump.ghul"

cleanup() { rm -f "$dump"; }
trap cleanup EXIT

cat > "$dump" <<'GHUL'
namespace LLVM.UnitTests is
    use LLVM.WRITER
    use LLVM.Tests.MODULE_MATRIX

    use TestClass = Microsoft.VisualStudio.TestTools.UnitTesting.TestClassAttribute
    use Test = Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute

    // Written and removed by llvm-check.sh; it exists only to dump the
    // matrix where the LLVM tools can reach it.
    @TestClass()
    class LLVM_DUMP_TESTS is
        init() is si

        @Test()
        write__every_module() is
            let dir = System.Environment.get_environment_variable("LLVM_MATRIX_DIR") ?? "/tmp/llvm-matrix"

            for name in MODULE_MATRIX.names() do
                IO.File.write_all_text("{dir}/{name}.ll", WRITER.module_text(MODULE_MATRIX.by_name(name)))
            od
        si
    si
si
GHUL

echo "writing the matrix to $out"
test_log="$(LLVM_MATRIX_DIR="$out" dotnet test "$here/llvm-tests.ghulproj" \
    --filter "FullyQualifiedName~LLVM_DUMP" --nologo -v q 2>&1)"

count=$(ls "$out"/*.ll 2>/dev/null | wc -l)
if [ "$count" -eq 0 ]; then
    echo "llvm-check: no modules were written; the test run failed:" >&2
    echo "$test_log" | grep -E "error|Failed" >&2
    exit 1
fi

failures=0

for f in "$out"/*.ll; do
    name="$(basename "$f" .ll)"
    bc="$out/$name.bc"
    obj="$out/$name.o"

    if ! log="$("$tool_llvm_as" "$f" -o "$bc" 2>&1)"; then
        echo "  REJECT  $name  (llvm-as)"
        echo "$log" | sed 's/^/          /'
        failures=$((failures + 1))
        continue
    fi

    if ! log="$("$tool_opt" -passes=verify "$bc" -o /dev/null 2>&1)"; then
        echo "  REJECT  $name  (opt -passes=verify)"
        echo "$log" | sed 's/^/          /'
        failures=$((failures + 1))
        continue
    fi

    if ! log="$("$tool_llc" -filetype=obj "$bc" -o "$obj" 2>&1)"; then
        echo "  REJECT  $name  (llc)"
        echo "$log" | sed 's/^/          /'
        failures=$((failures + 1))
        continue
    fi

    echo "  ok      $name"
done

echo
echo "$count modules, $failures rejection(s)"
[ "$failures" -eq 0 ]
