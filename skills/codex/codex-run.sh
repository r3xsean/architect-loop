#!/usr/bin/env bash
# Run Codex as a subagent with a routed GPT-5.6 profile, YOLO permissions,
# and resumable sessions.
#
# Usage:
#   codex-run.sh <sol-medium|sol-xhigh|luna-xhigh> [THREAD_ID]
#     <<'EOF' ... prompt ... EOF
#
# Prompt is always read from stdin. Prints:
#   THREAD_ID=<id>
#   ---
#   <Codex's final answer>
set -euo pipefail

PROFILE=${1:?usage: codex-run.sh <sol-medium|sol-xhigh|luna-xhigh> [THREAD_ID]}
shift

case "$PROFILE" in
  sol-medium) MODEL=${ARCHITECT_LOOP_SOL_MODEL:-gpt-5.6-sol}; EFFORT=medium ;;
  sol-xhigh)  MODEL=${ARCHITECT_LOOP_SOL_MODEL:-gpt-5.6-sol}; EFFORT=xhigh ;;
  luna-xhigh) MODEL=${ARCHITECT_LOOP_LUNA_MODEL:-gpt-5.6-luna}; EFFORT=xhigh ;;
  *) echo "error: unknown profile '$PROFILE'" >&2; exit 2 ;;
esac

if [ $# -gt 1 ]; then
  echo "error: the prompt goes on stdin; only an optional thread ID may follow the profile" >&2
  exit 2
fi

if [ "${ARCHITECT_LOOP_DRY_RUN:-0}" = 1 ]; then
  printf 'model=%s effort=%s yolo=true\n' "$MODEL" "$EFFORT"
  exit 0
fi

ANSWER=$(mktemp) EVENTS=$(mktemp)
trap 'rm -f "$ANSWER" "$EVENTS"' EXIT

FLAGS=(-m "$MODEL" -c model_reasoning_effort="$EFFORT"
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
