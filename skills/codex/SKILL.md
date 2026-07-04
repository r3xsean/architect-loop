---
name: codex
description: Delegate work to Codex (OpenAI's coding agent) as a subagent. Use when the user says "ask codex", "have codex do/check/review X", wants a second opinion from a non-Claude model, or wants work run in parallel on another model.
---

# Codex as a subagent

Run Codex through the wrapper — it pins the model (`gpt-5.5`), effort (`xhigh`), and full-autonomy flags (no approval prompts, no sandbox), and makes every run resumable:

```bash
cd "<working-dir>" && ~/.claude/skills/codex/codex-run.sh [THREAD_ID] <<'CODEX_PROMPT'
<prompt>
CODEX_PROMPT
```

Prompt always on stdin, exactly as above: a heredoc whose delimiter is **quoted** (`<<'CODEX_PROMPT'`, not `<<CODEX_PROMPT`) so quotes, `$`, and backticks in the prompt pass through literally. Never pass the prompt as a shell argument or inside quotes — that's where escaping breaks. If the prompt could itself contain a `CODEX_PROMPT` line (e.g. it embeds this skill), write it to a file with the Write tool and use `codex-run.sh [THREAD_ID] < prompt.md` instead.

Omit `THREAD_ID` for a new session; pass one to resume that session with its full context intact. Output is `THREAD_ID=<id>`, a `---` separator, then Codex's final answer — keep the thread ID as long as follow-ups are plausible.

Codex is a subagent: it shares your filesystem but none of your conversation. Any work fits — implementation, review, research, debugging, a second opinion — as long as the prompt carries everything it needs. It works in the directory you invoke it from.

## Steps

1. **Compose a self-contained prompt.** Include absolute file paths, the relevant context from this conversation, and the exact deliverable (e.g. "write the fix to X", "reply with a verdict and reasons"). For a follow-up, resume the earlier thread instead of re-explaining.
2. **Run it in the background — always.** Launch with the Bash tool's `run_in_background: true`. Background tasks have no timeout; a foreground Bash call is hard-capped at 10 minutes and would kill a long Codex run mid-task. Never run it in the foreground, however small the task looks. Then pick one of two modes:
   - **Wait:** if the result gates your next step, block on the task (TaskOutput) until it completes.
   - **Continue:** if you have independent work, carry on with it — the completion notification arrives on its own; read the output file then.

   In both modes, however long it runs: don't kill it and don't start doing the delegated work yourself.
3. **Relay the result — the user sees nothing of Codex's output except through you.** Your report to the user must always include: (a) what Codex did (files created/changed, commands run, decisions taken), and (b) Codex's final answer — verbatim if short, otherwise a faithful summary that preserves its conclusions, reasoning, and caveats in Codex's own terms. Never compress to "Codex handled it" or blend its output into your own voice so it can't be told apart; attribute clearly ("Codex said/did …"). Don't silently redo or discard its work. If it errored or came back incomplete, report that too — verbatim error included — and resume the thread rather than quietly taking over.

## Reference

- **Model/effort overrides:** only when the user explicitly asks — never on your own judgment. The wrapper doesn't take overrides; call the CLI directly, mirroring its flags: `codex exec [resume <THREAD_ID>] -m <model> -c model_reasoning_effort=<effort> --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check --json -o <answer-file> -` (prompt on stdin; on new runs the thread ID is in the first `thread.started` JSON event).
- **Parallel fan-out:** launch several wrapper runs in the background at once; each is an independent thread with its own `THREAD_ID`.
- **Extra write access:** append `--add-dir <dir>` for directories outside the working root (wrapper passes no extra dirs; use the raw CLI).
- **Structured output:** raw CLI `--output-schema <schema.json>` forces the final message to match a JSON Schema.
