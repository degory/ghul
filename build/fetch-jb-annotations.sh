#!/usr/bin/env bash
# Fetch JetBrains/ExternalAnnotations into `tools/jetbrains-annotations/`
# if it isn't already populated, then trim it via filter-jb-annotations.sh.
#
# Idempotent: re-running with the folder populated is a no-op. Called from
# the `FetchJetBrainsAnnotations` MSBuild target in `ghul.ghulproj` so a
# fresh source checkout builds without manual setup, and from CI before
# `dotnet pack` so the published NuGet ships with the trimmed XML beside
# the compiler DLL.

set -euo pipefail

root_dir=$(cd "$(dirname "$0")/.." && pwd)
target="${root_dir}/tools/jetbrains-annotations"

# Already populated — nothing to do. Check for a representative
# subdirectory rather than just the folder, because an empty folder
# is the half-failed state we want to recover from.
if [[ -d "${target}/Microsoft.CSharp" ]]; then
    exit 0
fi

echo "fetch-jb-annotations: downloading from JetBrains/ExternalAnnotations..." >&2

tarball=$(mktemp)
extract_dir=$(mktemp -d)
trap 'rm -rf "${tarball}" "${extract_dir}"' EXIT

# Anonymous GitHub tarball — public repo, no auth required for a
# single download. `gh api` is preferred in CI (uses GITHUB_TOKEN
# for rate-limit headroom) but `curl` keeps the contributor path
# free of the `gh` dependency.
curl -fsSL -o "${tarball}" \
    "https://api.github.com/repos/JetBrains/ExternalAnnotations/tarball/master"

tar xzf "${tarball}" -C "${extract_dir}"

src=$(find "${extract_dir}" -maxdepth 1 -type d -name 'JetBrains-ExternalAnnotations-*' | head -1)
if [[ -z "${src}" ]]; then
    echo "fetch-jb-annotations: error: extracted tarball has unexpected layout" >&2
    exit 1
fi

mkdir -p "${target}"
cp -r "${src}/Annotations/.NETCore/." "${target}/"

"${root_dir}/build/filter-jb-annotations.sh" "${target}" >&2
