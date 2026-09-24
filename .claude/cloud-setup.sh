#!/usr/bin/env bash
# Setup script for the Claude Code cloud environment on this repository.
# Runs once per environment and is cached as a filesystem snapshot, so the
# cost is paid weekly rather than per session. Installs what the default
# image lacks: the .NET 10 SDK and this repository's local tools, then warms
# the NuGet cache with one build. gh is deliberately not installed.
set -euo pipefail

DOTNET_ROOT=/usr/local/dotnet
export DOTNET_ROOT DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1

if ! command -v dotnet >/dev/null 2>&1; then
  curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
  bash /tmp/dotnet-install.sh --channel 10.0 --install-dir "${DOTNET_ROOT}"
  ln -sf "${DOTNET_ROOT}/dotnet" /usr/local/bin/dotnet
fi
dotnet --version

dotnet tool restore
dotnet tool update --local ghul.compiler || true
dotnet build -nologo -verbosity:quiet || echo "warm build failed; the session builds on demand" >&2
