#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
FAILED=0

check_tree() {
  local source=$1 target=$2
  while IFS= read -r -d '' file; do
    local rel=${file#"$source"/}
    if ! cmp -s "$file" "$target/$rel"; then
      echo "drift: $target/$rel" >&2
      FAILED=1
    fi
  done < <(find "$source" -type f -print0)
}

check_tree "$ROOT/skills" "$HOME/.claude/skills"
check_tree "$ROOT/skills" "$HOME/.agents/skills"
check_tree "$ROOT/agents-skills" "$HOME/.agents/skills"

expect_profile() {
  local expected=$1
  shift
  local actual
  actual=$(ARCHITECT_LOOP_DRY_RUN=1 \
    ARCHITECT_LOOP_SOL_MODEL= ARCHITECT_LOOP_LUNA_MODEL= ARCHITECT_LOOP_FABLE_MODEL= \
    "$@")
  if [ "$actual" != "$expected" ]; then
    echo "profile mismatch: expected '$expected', got '$actual'" >&2
    FAILED=1
  fi
}

expect_profile 'model=gpt-5.6-sol effort=medium yolo=true' \
  "$ROOT/skills/codex/codex-run.sh" sol-medium
expect_profile 'model=gpt-5.6-sol effort=xhigh yolo=true' \
  "$ROOT/skills/codex/codex-run.sh" sol-xhigh
expect_profile 'model=gpt-5.6-luna effort=xhigh yolo=true' \
  "$ROOT/skills/codex/codex-run.sh" luna-xhigh
expect_profile 'model=fable effort=medium yolo=true' \
  "$ROOT/agents-skills/claude/claude-run.sh" fable-medium
expect_profile 'model=fable effort=high yolo=true' \
  "$ROOT/agents-skills/claude/claude-run.sh" fable-high

if rg -n -i --glob 'SKILL.md' --glob '*.sh' \
  'gpt-5\.5|model: opus|claude-run\.sh opus|gpt-5\.6-terra|mandatory grok' \
  "$ROOT/skills" "$ROOT/agents-skills"; then
  echo "stale model route found" >&2
  FAILED=1
fi

if ! rg -q -- '--dangerously-bypass-approvals-and-sandbox' \
  "$ROOT/skills/codex/codex-run.sh"; then
  echo "Codex wrapper is not YOLO" >&2
  FAILED=1
fi

if ! rg -q -- '--dangerously-skip-permissions' \
  "$ROOT/agents-skills/claude/claude-run.sh"; then
  echo "Claude wrapper is not YOLO" >&2
  FAILED=1
fi

exit "$FAILED"
