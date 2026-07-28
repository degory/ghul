#!/usr/bin/env bash
#
# coverage.sh — measure how much of the compiler's own ghūl source the test
# suites execute.
#
# The compiler is built with debug information so ilasm emits a Portable PDB
# mapping IL back to .ghul source. coverlet rewrites the built assembly to
# record which sequence points are hit, the suites run against the rewritten
# assembly, and ReportGenerator merges the per-suite results into one report.
#
# Coverage is attributed to .ghul files, so any tool that reads lcov or
# Cobertura can display it — including the Coverage Gutters VS Code extension,
# which picks up coverage/report/lcov.info with no configuration.
#
# Usage:
#   build/coverage.sh [options]
#
# Options:
#   -s, --suite <name>   Suite to measure; repeatable. One of:
#                          integration     (default) integration-tests
#                          cross-assembly  cross-assembly-tests
#                          all             both of the above
#   -f, --filter <path>  Restrict a suite to one subdirectory, e.g.
#                        integration-tests/semantic. Implies a single suite.
#   -n, --no-build       Reuse the existing publish/ tree. Only safe when it
#                        was produced by this script (it needs the PDB).
#   -o, --output <dir>   Output directory (default: coverage/).
#   -h, --help           Show this help.
#
# Unit and analysis tests are not included: they run through `dotnet test`
# against bin/, not publish/, so they need coverlet.collector wired into their
# project files rather than this out-of-process instrumentation. Until that is
# done, treat a low number on a file as "not covered by end-to-end tests"
# rather than "not covered at all".
#
set -euo pipefail

die() { echo "coverage: $*" >&2; exit 1; }
usage() { sed -n '2,/^set -euo/p' "$0" | sed 's/^# \{0,1\}//; /^set -euo/d'; exit "${1:-0}"; }

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# ---- parse arguments -------------------------------------------------------
suites=()
filter=""
build=1
output="coverage"
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage 0 ;;
        -s|--suite)
            case "${2:?--suite needs a name}" in
                integration|cross-assembly|all) suites+=("$2") ;;
                *) die "unknown suite: $2 (see --help)" ;;
            esac
            shift 2 ;;
        -f|--filter) filter="${2:?--filter needs a path}"; shift 2 ;;
        -n|--no-build) build=0; shift ;;
        -o|--output) output="${2:?--output needs a dir}"; shift 2 ;;
        *) die "unknown option: $1 (see --help)" ;;
    esac
done
[[ ${#suites[@]} -gt 0 ]] || suites=(integration)

# `all` anywhere in the list means every suite, and a suite named twice runs
# once, so any combination of repeats does what it looks like.
expanded=()
for suite in "${suites[@]}"; do
    if [[ "$suite" == "all" ]]; then
        expanded=(integration cross-assembly)
        break
    fi
    if [[ " ${expanded[*]:-} " != *" $suite "* ]]; then
        expanded+=("$suite")
    fi
done
suites=("${expanded[@]}")
if [[ -n "$filter" && ${#suites[@]} -ne 1 ]]; then
    die "--filter applies to a single suite"
fi

# ---- tooling ---------------------------------------------------------------
# Kept in a script-private tool path so the committed manifest, and every
# other job that restores it, stay untouched.
tools="$repo_root/.coverage-tools"
ensure_tool() {
    local package="$1" command="$2"
    if [[ ! -x "$tools/$command" ]]; then
        echo "coverage: installing $package"
        dotnet tool install "$package" --tool-path "$tools" >/dev/null \
            || die "could not install $package"
    fi
}
ensure_tool coverlet.console coverlet
ensure_tool dotnet-reportgenerator-globaltool reportgenerator

# ---- build with debug information -----------------------------------------
# DebugType/DebugSymbols are what the ghūl MSBuild targets consult to decide
# whether to pass --debug to the compiler. They are set here rather than in
# ghul.ghulproj so that ordinary builds — and the released package — stay free
# of debug information and the JIT optimization it suppresses.
if [[ "$build" -eq 1 ]]; then
    echo "coverage: building compiler with debug information"
    dotnet publish --output publish/ -p:DebugType=portable -p:DebugSymbols=true \
        || die "build failed"
fi
[[ -f publish/ghul.dll ]] || die "publish/ghul.dll not found; drop --no-build"
[[ -f publish/ghul.pdb ]] || die "publish/ghul.pdb not found; publish/ was built without debug information, drop --no-build"

rm -rf "$output"
mkdir -p "$output"

# ---- run each suite under instrumentation ---------------------------------
# coverlet rewrites publish/ghul.dll in place, runs the target, then restores
# the original. Every compiler process the harness spawns — directly, or via
# MSBuild for the cross-assembly suite — is the instrumented one, and their
# hit counts accumulate into a single file under a mutex, so the suites'
# internal parallelism is not a problem.
run_suite() {
    local suite="$1" target
    case "$suite" in
        integration)    target="${filter:-integration-tests}" ;;
        cross-assembly) target="${filter:-cross-assembly-tests}" ;;
        *) die "unknown suite: $suite (see --help)" ;;
    esac
    [[ -e "$target" ]] || die "no such test path: $target"

    local args="ghul-test $target"
    [[ "$suite" == "cross-assembly" ]] && args="ghul-test --use-dotnet-build $target"

    echo "coverage: running $suite ($target)"
    local start=$SECONDS
    # A failing test still leaves usable coverage, so record the outcome and
    # carry on rather than losing the run to `set -e`.
    local status=0
    "$tools/coverlet" publish/ghul.dll \
        --target dotnet \
        --targetargs "$args" \
        --format cobertura \
        --output "$output/$suite.cobertura.xml" \
        --include-test-assembly \
        || status=$?
    echo "coverage: $suite finished in $((SECONDS - start))s (exit $status)"
    [[ "$status" -eq 0 ]] || echo "coverage: warning: $suite reported failures; coverage below still reflects what ran"
}

for suite in "${suites[@]}"; do
    run_suite "$suite"
done

# ---- merge and report ------------------------------------------------------
reports=("$output"/*.cobertura.xml)
[[ -e "${reports[0]}" ]] || die "no coverage reports were produced"

echo "coverage: merging ${#reports[@]} report(s)"
"$tools/reportgenerator" \
    "-reports:$output/*.cobertura.xml" \
    "-targetdir:$output/report" \
    "-reporttypes:Html;Cobertura;lcov;Badges;MarkdownSummaryGithub;TextSummary" \
    "-filefilters:-*/obj/*" \
    >/dev/null || die "report generation failed"

echo
if [[ -f "$output/report/Summary.txt" ]]; then
    sed -n '1,12p' "$output/report/Summary.txt"
    echo
fi
echo "coverage: wrote"
echo "  $output/report/index.html            browse"
echo "  $output/report/lcov.info             VS Code (Coverage Gutters: Display Coverage)"
echo "  $output/report/Cobertura.xml         machine-readable"
echo "  $output/report/SummaryGithub.md      job summary for a CI run"
echo "  $output/report/badge_*.svg           coverage badges"

# On a GitHub runner, surface the summary on the run's own page. Nothing is
# written anywhere else, so this stays inert locally.
if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    cat "$output/report/SummaryGithub.md" >> "$GITHUB_STEP_SUMMARY"
    echo "coverage: appended summary to the job summary"
fi
