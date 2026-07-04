#!/usr/bin/env bash
# Run Claude Code as a subagent, with fixed effort and resumable sessions.
#
# Usage:
#   claude-run.sh <fable|opus>              <<'EOF' ... prompt ... EOF   # new session
#   claude-run.sh <fable|opus> <SESSION_ID> <<'EOF' ... prompt ... EOF   # resume session
#
# Prompt is always read from stdin. Prints:
#   SESSION_ID=<id>
#   ---
#   <Claude's final answer>
set -euo pipefail

MODEL=${1:?usage: claude-run.sh <fable|opus> [SESSION_ID]  (prompt on stdin)}
case "$MODEL" in
  fable|opus) ;;
  *) echo "error: model must be fable or opus, got '$MODEL'" >&2; exit 2 ;;
esac

UUID_RE='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
if [ $# -ge 2 ] && [ -n "$2" ]; then
  if ! [[ $2 =~ $UUID_RE ]]; then
    echo "error: '$2' is not a session ID (UUID). The prompt goes on stdin, never as an argument." >&2
    exit 2
  fi
  SESSION_ID=$2
  SESSFLAG=(--resume "$SESSION_ID")
else
  SESSION_ID=$(uuidgen | tr '[:upper:]' '[:lower:]')
  SESSFLAG=(--session-id "$SESSION_ID")
fi

echo "SESSION_ID=$SESSION_ID"
echo "---"
exec claude -p --model "$MODEL" --effort high --dangerously-skip-permissions "${SESSFLAG[@]}"
