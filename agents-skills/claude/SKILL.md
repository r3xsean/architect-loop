---
name: claude
description: Delegate work to Claude Code (Anthropic's coding agent) as a subagent. Use when the user says "ask claude", "have claude do/check/review X", wants a second opinion from a non-OpenAI model, or wants work run in parallel on another model.
---

# Claude Code as a subagent

Run Claude through the wrapper. It pins Fable at the routed effort, always bypasses permission checks, and makes every run resumable:

```bash
cd "<working-dir>" && ~/.agents/skills/claude/claude-run.sh <fable-medium|fable-high> [SESSION_ID] <<'CLAUDE_PROMPT'
<prompt>
CLAUDE_PROMPT
```

Prompt always on stdin, with a quoted heredoc delimiter so quotes, `$`, and backticks pass through literally. Never pass the prompt as a shell argument. If it could contain the delimiter line, write it to a file and redirect stdin.

Omit `SESSION_ID` for a new session; pass one to resume with the same profile. Output is `SESSION_ID=<id>`, a `---` separator, then Claude's final answer.

Pick the profile from the consequence of the judgment:

- **`fable-medium`** — normal architecture, planning, review, writing, diagnosis, and design direction.
- **`fable-high`** — one-way doors, taste-critical work, systemic failures, public positioning, and high-blast-radius review.

The wrapper always runs YOLO. Model autonomy does not grant product authority: commits, publishing, messages, production mutation, and other irreversible actions still require the user's explicit instruction.

Claude is a subagent: it shares your filesystem but none of your conversation. Any work fits — implementation, review, research, debugging, a second opinion — as long as the prompt carries everything it needs. It works in the directory you invoke it from.

## Steps

1. **Pick a profile, then compose a self-contained prompt.** Include absolute file paths, relevant context, and the exact deliverable. Resume follow-ups instead of re-explaining.
2. **Run it, then wait or continue — never kill it.** Run the wrapper with `exec_command`; when it yields a session ID instead of finishing, the command is still running. Pick one of two modes:
   - **Wait:** if the result gates your next step, sit on the exec session with empty `write_stdin` polls — each poll blocks up to 300 s and returns the instant the process exits, marked explicitly by `Process exited with code N`. Repeat as many times as it takes, for hours if necessary.
   - **Continue:** if you have independent work, keep the exec session ID, do that work, and poll between tasks until you see the exit marker. There is no async notification — the session only reports when you poll, so don't forget to come back to it.

   Until you've seen `Process exited with code N`, Claude is still working. A quiet session is normal on hard tasks, not a hang: do not terminate the session, re-run the command, or take over the delegated work yourself because it's taking long.
3. **Relay the result — the user sees nothing of Claude's output except through you.** Your report to the user must always include: (a) what Claude did (files created/changed, commands run, decisions taken), and (b) Claude's final answer — verbatim if short, otherwise a faithful summary that preserves its conclusions, reasoning, and caveats in Claude's own terms. Never compress to "Claude handled it" or blend its output into your own voice so it can't be told apart; attribute clearly ("Claude said/did …"). Don't silently redo or discard its work. If it errored or came back incomplete, report that too — verbatim error included — and resume the session rather than quietly taking over.

## Reference

- **Model override:** set `ARCHITECT_LOOP_FABLE_MODEL` only when access requires an explicit compatible Fable model. There is no Opus route and no automatic fallback.
- **Validation:** set `ARCHITECT_LOOP_DRY_RUN=1` to print the resolved model, effort, and YOLO state without starting a session.
- **Parallel fan-out:** launch several wrapper runs at once; each is an independent session with its own `SESSION_ID`.
- **Extra directory access:** append `--add-dir <dir...>` via the raw CLI.
- **Structured output:** raw CLI `--json-schema <schema>` forces structured output; `--output-format json` wraps the result with metadata (cost, duration).
