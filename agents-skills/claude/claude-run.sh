#!/usr/bin/env bash
# Run Claude Code as a subagent with a routed Fable profile, YOLO permissions,
# and resumable sessions.
#
# Usage:
#   claude-run.sh <fable-medium|fable-high> [SESSION_ID]
#     <<'EOF' ... prompt ... EOF
#
# Prompt is always read from stdin. Prints:
#   SESSION_ID=<id>
#   ---
#   <Claude's final answer>
set -euo pipefail

PROFILE=${1:?usage: claude-run.sh <fable-medium|fable-high> [SESSION_ID]}
shift

MODEL=${ARCHITECT_LOOP_FABLE_MODEL:-fable}
case "$PROFILE" in
  fable-medium) EFFORT=medium ;;
  fable-high) EFFORT=high ;;
  *) echo "error: unknown profile '$PROFILE'" >&2; exit 2 ;;
esac

if [ $# -gt 1 ]; then
  echo "error: the prompt goes on stdin; only an optional session ID may follow the profile" >&2
  exit 2
fi

if [ "${ARCHITECT_LOOP_DRY_RUN:-0}" = 1 ]; then
  printf 'model=%s effort=%s yolo=true\n' "$MODEL" "$EFFORT"
  exit 0
fi

UUID_RE='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
if [ $# -eq 1 ] && [ -n "$1" ]; then
  if ! [[ $1 =~ $UUID_RE ]]; then
    echo "error: '$1' is not a session ID (UUID). The prompt goes on stdin, never as an argument." >&2
    exit 2
  fi
  SESSION_ID=$1
  SESSFLAG=(--resume "$SESSION_ID")
else
  SESSION_ID=$(uuidgen | tr '[:upper:]' '[:lower:]')
  SESSFLAG=(--session-id "$SESSION_ID")
fi

echo "SESSION_ID=$SESSION_ID"
echo "---"
exec claude -p --model "$MODEL" --effort "$EFFORT" --dangerously-skip-permissions "${SESSFLAG[@]}"
