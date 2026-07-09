---
name: codex
description: Delegate work to Codex (OpenAI's coding agent) as a subagent. Use when the user says "ask codex", "have codex do/check/review X", wants a second opinion from a non-Claude model, or wants work run in parallel on another model.
---

# Codex as a subagent

Run Codex through the wrapper. It maps the loop's three GPT profiles to concrete models and efforts, always bypasses approvals and sandboxing, and makes every run resumable:

```bash
cd "<working-dir>" && ~/.claude/skills/codex/codex-run.sh <sol-medium|sol-xhigh|luna-xhigh> [THREAD_ID] <<'CODEX_PROMPT'
<prompt>
CODEX_PROMPT
```

Prompt always on stdin, exactly as above: a heredoc whose delimiter is **quoted** (`<<'CODEX_PROMPT'`, not `<<CODEX_PROMPT`) so quotes, `$`, and backticks in the prompt pass through literally. Never pass the prompt as a shell argument. If the prompt could contain a `CODEX_PROMPT` line, write it to a file and redirect stdin.

Pick the profile from the work, never from habit:

- **`sol-medium`** — normal implementation, research, debugging, artifacts, browser/computer work, aggregation, and normal review of Fable-made work.
- **`sol-xhigh`** — ambiguous, long-running, security-sensitive, expensive-to-recover work, and consequential review of Fable-made work.
- **`luna-xhigh`** — bounded, repetitive leaf work whose output Sol will check or aggregate. Never architecture, final synthesis, or final review.

The wrapper always runs YOLO. Model autonomy does not grant product authority: commits, publishing, messages, production mutation, and other irreversible actions still require the user's explicit instruction.

Omit `THREAD_ID` for a new session; pass one to resume with the same profile. Output is `THREAD_ID=<id>`, a `---` separator, then Codex's final answer.

Codex is a subagent: it shares your filesystem but none of your conversation. Any work fits — implementation, review, research, debugging, a second opinion — as long as the prompt carries everything it needs. It works in the directory you invoke it from.

## Steps

1. **Pick a profile, then compose a self-contained prompt.** Include absolute file paths, relevant context, the exact deliverable, and the check that bounds Luna work. Resume follow-ups instead of re-explaining.
2. **Run it in the background — always.** Launch with the Bash tool's `run_in_background: true`. Background tasks have no timeout; a foreground Bash call is hard-capped at 10 minutes and would kill a long Codex run mid-task. Never run it in the foreground, however small the task looks. Then pick one of two modes:
   - **Wait:** if the result gates your next step, block on the task (TaskOutput) until it completes.
   - **Continue:** if you have independent work, carry on with it — the completion notification arrives on its own; read the output file then.

   In both modes, however long it runs: don't kill it and don't start doing the delegated work yourself.
3. **Relay the result — the user sees nothing of Codex's output except through you.** Your report to the user must always include: (a) what Codex did (files created/changed, commands run, decisions taken), and (b) Codex's final answer — verbatim if short, otherwise a faithful summary that preserves its conclusions, reasoning, and caveats in Codex's own terms. Never compress to "Codex handled it" or blend its output into your own voice so it can't be told apart; attribute clearly ("Codex said/did …"). Don't silently redo or discard its work. If it errored or came back incomplete, report that too — verbatim error included — and resume the thread rather than quietly taking over.

## Reference

- **Model overrides:** set `ARCHITECT_LOOP_SOL_MODEL` or `ARCHITECT_LOOP_LUNA_MODEL` only when access requires an explicit compatible model. There is no automatic fallback.
- **Validation:** set `ARCHITECT_LOOP_DRY_RUN=1` to print the resolved model, effort, and YOLO state without starting a thread.
- **Parallel fan-out:** launch several wrapper runs in the background at once; each is an independent thread with its own `THREAD_ID`.
- **Extra write access:** append `--add-dir <dir>` for directories outside the working root (wrapper passes no extra dirs; use the raw CLI).
- **Structured output:** raw CLI `--output-schema <schema.json>` forces the final message to match a JSON Schema.
