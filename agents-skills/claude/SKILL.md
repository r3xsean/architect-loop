---
name: claude
description: Delegate work to Claude Code (Anthropic's coding agent) as a subagent. Use when the user says "ask claude", "have claude do/check/review X", wants a second opinion from a non-OpenAI model, or wants work run in parallel on another model.
---

# Claude Code as a subagent

Run Claude through the wrapper — it pins the effort (`high`) and full-autonomy flag (all permission checks bypassed), validates the model, and makes every run resumable:

```bash
cd "<working-dir>" && ~/.agents/skills/claude/claude-run.sh <fable|opus> [SESSION_ID] <<'CLAUDE_PROMPT'
<prompt>
CLAUDE_PROMPT
```

Prompt always on stdin, exactly as above: a heredoc whose delimiter is **quoted** (`<<'CLAUDE_PROMPT'`, not `<<CLAUDE_PROMPT`) so quotes, `$`, and backticks in the prompt pass through literally. Never pass the prompt as a shell argument or inside quotes — that's where escaping breaks. If the prompt could itself contain a `CLAUDE_PROMPT` line (e.g. it embeds this skill), write the prompt to a file first and use `claude-run.sh <fable|opus> [SESSION_ID] < prompt.md` instead.

Omit `SESSION_ID` for a new session; pass one to resume that session with its full context intact (keep the same model it started with). Output is `SESSION_ID=<id>`, a `---` separator, then Claude's final answer — keep the session ID as long as follow-ups are plausible.

The only models are `fable` and `opus`; pick by the nature of the work:

- **`opus` — execution.** The task is well specified and success is checkable: implementing to a clear spec, mechanical refactors, running and fixing tests, research legwork, summarizing code.
- **`fable` — judgment.** The task turns on taste or hard reasoning: design and architecture decisions, gnarly debugging, second opinions, reviews where subtle bugs matter, writing quality. Fable is much smarter but much more expensive — spend it where judgment is the deliverable. Also escalate to fable when an opus attempt comes back wrong or muddled, rather than retrying opus.

Claude is a subagent: it shares your filesystem but none of your conversation. Any work fits — implementation, review, research, debugging, a second opinion — as long as the prompt carries everything it needs. It works in the directory you invoke it from.

## Steps

1. **Compose a self-contained prompt.** Include absolute file paths, the relevant context from this conversation, and the exact deliverable (e.g. "write the fix to X", "reply with a verdict and reasons"). For a follow-up, resume the earlier session instead of re-explaining.
2. **Run it, then wait or continue — never kill it.** Run the wrapper with `exec_command`; when it yields a session ID instead of finishing, the command is still running. Pick one of two modes:
   - **Wait:** if the result gates your next step, sit on the exec session with empty `write_stdin` polls — each poll blocks up to 300 s and returns the instant the process exits, marked explicitly by `Process exited with code N`. Repeat as many times as it takes, for hours if necessary.
   - **Continue:** if you have independent work, keep the exec session ID, do that work, and poll between tasks until you see the exit marker. There is no async notification — the session only reports when you poll, so don't forget to come back to it.

   Until you've seen `Process exited with code N`, Claude is still working. A quiet session is normal on hard tasks, not a hang: do not terminate the session, re-run the command, or take over the delegated work yourself because it's taking long.
3. **Relay the result — the user sees nothing of Claude's output except through you.** Your report to the user must always include: (a) what Claude did (files created/changed, commands run, decisions taken), and (b) Claude's final answer — verbatim if short, otherwise a faithful summary that preserves its conclusions, reasoning, and caveats in Claude's own terms. Never compress to "Claude handled it" or blend its output into your own voice so it can't be told apart; attribute clearly ("Claude said/did …"). Don't silently redo or discard its work. If it errored or came back incomplete, report that too — verbatim error included — and resume the session rather than quietly taking over.

## Reference

- **Model/effort overrides:** only when the user explicitly asks — never on your own judgment. The wrapper doesn't take overrides; call the CLI directly: `claude -p --model <model> --effort <level> --dangerously-skip-permissions [--session-id <new-uuid>|--resume <SESSION_ID>]` (prompt on stdin; mint your own UUID with `uuidgen` so the run stays resumable).
- **Parallel fan-out:** launch several wrapper runs at once; each is an independent session with its own `SESSION_ID`.
- **Extra directory access:** append `--add-dir <dir...>` via the raw CLI.
- **Structured output:** raw CLI `--json-schema <schema>` forces structured output; `--output-format json` wraps the result with metadata (cost, duration).
