#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

mkdir -p "$HOME/.claude/skills" "$HOME/.agents/skills"
rsync -a "$ROOT/skills/" "$HOME/.claude/skills/"
rsync -a "$ROOT/skills/" "$HOME/.agents/skills/"
rsync -a "$ROOT/agents-skills/" "$HOME/.agents/skills/"

"$ROOT/scripts/check-routing.sh"
echo "Architect Loop skills installed and verified."
