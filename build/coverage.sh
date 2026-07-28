#!/usr/bin/env bash
#
# coverage.sh — measure how much of the compiler's own ghūl source the test
# suites execute.
#
# The compiler is built with debug information so ilasm emits a Portable PDB
# mapping IL back to .ghul source. For the integration and cross-assembly
# suites, coverlet rewrites the built assembly to record which sequence
# points are hit; unit tests use coverlet's in-process VSTest collector
# instead, since they call into the compiler directly rather than spawning
# it. ReportGenerator turns each suite's result into its own report, and all
# of them together into one combined report.
#
# Coverage is attributed to .ghul files, so any tool that reads lcov or
# Cobertura can display it — including the Coverage Gutters VS Code
# extension, which picks up coverage/report/lcov.info with no configuration.
#
# Usage:
#   build/coverage.sh [options]
#
# Options:
#   -s, --suite <name>   Suite to measure; repeatable. One of:
#                          integration     (default) integration-tests
#                          cross-assembly  cross-assembly-tests
#                          unit            unit-tests
#                          analysis        analysis-tests
#                          all             every suite above
#   -f, --filter <path>  Restrict the integration or cross-assembly suite to
#                        one subdirectory, e.g. integration-tests/semantic.
#                        Implies a single suite of one of those two kinds.
#   -n, --no-build       Reuse the existing publish/ tree for the integration
#                        and cross-assembly suites. Only safe when it was
#                        produced by this script (it needs the PDB). Unit and
#                        analysis tests always build fresh; both are quick.
#   -o, --output <dir>   Output directory (default: coverage/).
#   -h, --help           Show this help.
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
                integration|cross-assembly|unit|analysis|all) suites+=("$2") ;;
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
        expanded=(integration cross-assembly unit analysis)
        break
    fi
    if [[ " ${expanded[*]:-} " != *" $suite "* ]]; then
        expanded+=("$suite")
    fi
done
suites=("${expanded[@]}")

if [[ -n "$filter" ]]; then
    [[ ${#suites[@]} -eq 1 ]] || die "--filter applies to a single suite"
    case "${suites[0]}" in
        integration|cross-assembly) ;;
        *) die "--filter only applies to the integration or cross-assembly suites" ;;
    esac
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

# ---- build the compiler with debug information -----------------------------
# Only the integration and cross-assembly suites need publish/: they spawn
# the compiler out of process, from a path each test's ghul.json names
# explicitly. DebugType/DebugSymbols are what the ghūl MSBuild targets
# consult to decide whether to pass --debug to the compiler; setting them
# here rather than in ghul.ghulproj keeps ordinary builds, and the released
# package, free of debug information and the JIT optimization it suppresses.
needs_publish=0
for suite in "${suites[@]}"; do
    [[ "$suite" == "integration" || "$suite" == "cross-assembly" ]] && needs_publish=1
done

if [[ "$needs_publish" -eq 1 ]]; then
    if [[ "$build" -eq 1 ]]; then
        echo "coverage: building compiler with debug information"
        dotnet publish --output publish/ -p:DebugType=portable -p:DebugSymbols=true \
            || die "build failed"
    fi
    [[ -f publish/ghul.dll ]] || die "publish/ghul.dll not found; drop --no-build"
    [[ -f publish/ghul.pdb ]] || die "publish/ghul.pdb not found; publish/ was built without debug information, drop --no-build"
fi

rm -rf "$output"
mkdir -p "$output"

# ---- run each suite under instrumentation ---------------------------------
# The integration and cross-assembly suites spawn the compiler as a separate
# process — directly, or via MSBuild for cross-assembly — many times over,
# so coverlet instruments publish/ghul.dll itself; every spawned process
# runs the instrumented copy and merges its hit counts into one file under a
# mutex, so the suites' internal parallelism is not a problem.
run_out_of_process_suite() {
    local suite="$1" target
    case "$suite" in
        integration)    target="${filter:-integration-tests}" ;;
        cross-assembly) target="${filter:-cross-assembly-tests}" ;;
    esac
    [[ -e "$target" ]] || die "no such test path: $target"

    local args="ghul-test $target"
    [[ "$suite" == "cross-assembly" ]] && args="ghul-test --use-dotnet-build $target"

    echo "coverage: running $suite ($target)"
    local start=$SECONDS
    # A failing test still leaves usable coverage, so record the outcome and
    # carry on rather than losing the run to `set -e`.
    local status=0
    # GitHub Actions sets CI=true for every job. ghul-test reads that and
    # defaults to COMPILER_RUN_MODE.CI, which runs the pinned `dotnet
    # ghul-compiler` tool instead of discovering publish/ghul.dll — the exact
    # file just instrumented above — so the suite runs at its normal,
    # uninstrumented speed and coverage comes back empty. --use-dotnet-build
    # already sidesteps this for cross-assembly by forcing DOTNET mode
    # outright; clearing CI here gets the plain integration run the same
    # publish/ discovery by falling back to LOCAL mode.
    CI= "$tools/coverlet" publish/ghul.dll \
        --target dotnet \
        --targetargs "$args" \
        --format cobertura \
        --output "$output/$suite.cobertura.xml" \
        --include-test-assembly \
        || status=$?
    echo "coverage: $suite finished in $((SECONDS - start))s (exit $status)"
    [[ "$status" -eq 0 ]] || echo "coverage: warning: $suite reported failures; coverage below still reflects what ran"
}

# Unit tests call into the compiler in the same process, so coverlet.collector
# (referenced from unit-tests.ghulproj) attaches through the standard VSTest
# data-collector protocol instead — no separate instrumentation step.
run_unit_suite() {
    echo "coverage: running unit"
    local start=$SECONDS
    local raw="$output/.raw-unit"
    rm -rf "$raw"
    local status=0
    dotnet test unit-tests --collect:"XPlat Code Coverage" --results-directory "$raw" \
        || status=$?
    local produced
    produced="$(find "$raw" -name 'coverage.cobertura.xml' -print -quit)"
    [[ -n "$produced" ]] || die "unit test coverage file was not produced"
    cp "$produced" "$output/unit.cobertura.xml"
    rm -rf "$raw"
    echo "coverage: unit finished in $((SECONDS - start))s (exit $status)"
    [[ "$status" -eq 0 ]] || echo "coverage: warning: unit reported failures; coverage below still reflects what ran"
}

# Analysis tests spawn the compiler as a subprocess too (analyser_process.ghul
# launches the ghul.dll that lands in analysis-tests/bin/ via ProjectReference),
# so this instruments that copy directly rather than going through publish/.
# Built explicitly first, and run with --no-build after, so `dotnet test`
# cannot silently rebuild over the instrumented copy mid-run.
run_analysis_suite() {
    echo "coverage: building analysis-tests"
    local config="Debug"
    dotnet build analysis-tests -c "$config" >/dev/null || die "analysis-tests build failed"
    local dll="analysis-tests/bin/$config/net10.0/ghul.dll"
    [[ -f "$dll" ]] || die "$dll not found after build"
    [[ -f "${dll%.dll}.pdb" ]] || die "${dll%.dll}.pdb not found; analysis-tests was built without debug information"

    echo "coverage: running analysis"
    local start=$SECONDS
    local status=0
    "$tools/coverlet" "$dll" \
        --target dotnet \
        --targetargs "test analysis-tests -c $config --no-build" \
        --format cobertura \
        --output "$output/analysis.cobertura.xml" \
        --include-test-assembly \
        || status=$?
    echo "coverage: analysis finished in $((SECONDS - start))s (exit $status)"
    [[ "$status" -eq 0 ]] || echo "coverage: warning: analysis reported failures; coverage below still reflects what ran"
}

for suite in "${suites[@]}"; do
    case "$suite" in
        integration|cross-assembly) run_out_of_process_suite "$suite" ;;
        unit)                       run_unit_suite ;;
        analysis)                   run_analysis_suite ;;
        *) die "unknown suite: $suite (see --help)" ;;
    esac
done

# ---- report -----------------------------------------------------------------
reports=("$output"/*.cobertura.xml)
[[ -e "${reports[0]}" ]] || die "no coverage reports were produced"

# analysis-tests is the test project itself, not compiler source, so its own
# coverage number is meaningless noise — always excluded. analysis-protocol
# is the shared DTO project; none of today's suites exercise much of it, so
# it's excluded for now too rather than reporting a permanently-red number.
assembly_filters="-assemblyfilters:-analysis-tests;-analysis-protocol"

# One report per suite, so a category can be inspected on its own.
for report in "${reports[@]}"; do
    suite_name="$(basename "$report" .cobertura.xml)"
    "$tools/reportgenerator" \
        "-reports:$report" \
        "-targetdir:$output/report/$suite_name" \
        "-reporttypes:Html;lcov" \
        "-filefilters:-*/obj/*" \
        "$assembly_filters" \
        >/dev/null || die "report generation failed for $suite_name"
done

# The combined report and headline number, generated at the report root so
# its badges and lcov sit at a stable path regardless of which suites ran.
echo "coverage: merging ${#reports[@]} report(s)"
"$tools/reportgenerator" \
    "-reports:$output/*.cobertura.xml" \
    "-targetdir:$output/report" \
    "-reporttypes:Html;Cobertura;lcov;Badges;MarkdownSummaryGithub;TextSummary" \
    "-filefilters:-*/obj/*" \
    "$assembly_filters" \
    >/dev/null || die "combined report generation failed"

echo
if [[ -f "$output/report/Summary.txt" ]]; then
    sed -n '1,12p' "$output/report/Summary.txt"
    echo
fi
echo "coverage: wrote"
echo "  $output/report/index.html            combined report"
echo "  $output/report/<suite>/index.html    per-suite report"
echo "  $output/report/lcov.info             VS Code (Coverage Gutters: Display Coverage)"
echo "  $output/report/Cobertura.xml         machine-readable"
echo "  $output/report/SummaryGithub.md      job summary for a CI run"
echo "  $output/report/badge_*.svg           coverage badges (combined)"

# On a GitHub runner, surface the summary on the run's own page. Nothing is
# written anywhere else, so this stays inert locally.
if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    cat "$output/report/SummaryGithub.md" >> "$GITHUB_STEP_SUMMARY"
    echo "coverage: appended summary to the job summary"
fi
