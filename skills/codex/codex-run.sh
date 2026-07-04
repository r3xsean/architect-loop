#!/usr/bin/env bash
# Run Codex as a subagent, with fixed model/effort and resumable sessions.
#
# Usage:
#   codex-run.sh              <<'EOF' ... prompt ... EOF   # new session
#   codex-run.sh <THREAD_ID>  <<'EOF' ... prompt ... EOF   # resume session
#
# Prompt is always read from stdin. Prints:
#   THREAD_ID=<id>
#   ---
#   <Codex's final answer>
set -euo pipefail

ANSWER=$(mktemp) EVENTS=$(mktemp)
trap 'rm -f "$ANSWER" "$EVENTS"' EXIT

FLAGS=(-m gpt-5.5 -c model_reasoning_effort=xhigh
       --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check
       --json -o "$ANSWER")

UUID_RE='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
if [ $# -ge 1 ] && [ -n "$1" ]; then
  if ! [[ $1 =~ $UUID_RE ]]; then
    echo "error: '$1' is not a thread ID (UUID). The prompt goes on stdin, never as an argument." >&2
    exit 2
  fi
  THREAD_ID=$1
  codex exec resume "$THREAD_ID" "${FLAGS[@]}" - >"$EVENTS"
else
  codex exec "${FLAGS[@]}" - >"$EVENTS"
  THREAD_ID=$(jq -r 'select(.type=="thread.started") | .thread_id' "$EVENTS" | head -1)
fi

echo "THREAD_ID=$THREAD_ID"
echo "---"
cat "$ANSWER"
echo
