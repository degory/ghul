#!/usr/bin/env bash
# PreToolUse guard for cloud sessions: a cloud session may push a branch named
# claude/... and nothing else on GitHub. Pull requests, comments, reviews,
# releases and pushes to other branches are refused here; the pull request is
# raised separately from the pushed branch.
set -euo pipefail

command=$(jq -r '.tool_input.command // empty' 2>/dev/null || true)
[ -n "${command}" ] || exit 0

refuse() {
  jq -n --arg reason "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
  exit 0
}

# gh is not used from a cloud session at all, nor installed.
if grep -qE '(^|[;&|[:space:]])(gh|apt(-get)?[[:space:]]+install[^;&|]*gh)([[:space:]]|$)' <<<"${command}"; then
  refuse "cloud sessions do not use gh; read GitHub with curl and leave the pull request to be raised from the branch"
fi
# curl or wget to GitHub with a write method or a body.
if grep -qE '(curl|wget)[^;&|]*github\.com' <<<"${command}" \
   && grep -qE -- '(-X|--request)[[:space:]]*(POST|PATCH|PUT|DELETE)|(^|[[:space:]])(-d|--data|--data-raw|--data-binary|--json|-T|--upload-file|--post-data)([[:space:]]|=)' <<<"${command}"; then
  refuse "cloud sessions read GitHub only; the pull request is raised separately from the pushed branch"
fi

# git push: only to claude/... branches, never delete, never main.
if grep -qE '(^|[;&|[:space:]])git[[:space:]]+([^;&|]*[[:space:]])?push([[:space:]]|$)' <<<"${command}"; then
  if grep -qE -- '(^|[[:space:]])(--delete|-d|--mirror|--all|--tags)([[:space:]]|$)|:[[:space:]]*(refs/heads/)?(main|master)([[:space:]]|$)|[[:space:]](refs/heads/)?(main|master)([[:space:]]|$)' <<<"${command}"; then
    refuse "cloud sessions push only to a branch named claude/<slug>"
  fi
  # A push that names its refspec is judged on it; a bare `git push`, or one
  # ending in `origin` or `HEAD`, is judged on the current branch.
  last=$(sed -E 's/[[:space:]]+$//; s/.*[[:space:]]([^[:space:]]+)$/\1/' <<<"${command}")
  case "${last}" in
    push|origin|HEAD|-*)
      branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
      case "${branch}" in
        claude/*|"") ;;
        *) refuse "cloud sessions push only to a branch named claude/<slug>; the current branch is ${branch}" ;;
      esac ;;
    claude/*|*:claude/*) ;;
    *) refuse "cloud sessions push only to a branch named claude/<slug>" ;;
  esac
fi

exit 0
