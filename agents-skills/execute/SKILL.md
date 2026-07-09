---
name: execute
description: Execute an approved code spec to merge-ready in one Sol session — work every ticket along the frontier with TDD, delegate checked leaves and taste seams, review cross-family until clean, then debrief. Use when asked to implement or complete a spec or ticket plan.
---

Run the standard whole-spec path in a fresh **GPT-5.6 Sol xhigh** session. A small, independently invoked routine ticket may use Sol medium. Input is the approved spec with its `## Tickets` section. **Fully automatic: never stop to ask.** Decide two-way doors conservatively and append them to the spec's `## Implementation Notes`; reserve true one-way doors for the final debrief unless no reversible path exists.

Read and apply the shared procedure dependencies directly:

- TDD: `~/.agents/skills/tdd/SKILL.md`
- Review: `~/.agents/skills/gauntlet/SKILL.md`
- Debrief: `~/.agents/skills/debrief/SKILL.md`
- Claude delegation: `~/.agents/skills/claude/SKILL.md`
- Codex leaf delegation: `~/.agents/skills/codex/SKILL.md`

## 1. Pin the territory

Read the complete spec, its existing Implementation Notes, every ticket, the repository guidance, domain glossary, and relevant ADRs. Pin the starting commit once; every final diff and review compares against it. Resolve the ticket graph and identify the current frontier.

Restate every ticket's acceptance criteria as checkable outcomes. Done when every requirement in the spec belongs to exactly one ticket and the next frontier is unambiguous.

## 2. Work the frontier

Take one unblocked ticket at a time. Before building it, derive its test seams from the acceptance criteria and classify each:

- **mechanical** — tests alone can establish correctness;
- **behavioral** — tests plus the acceptance contract establish correctness;
- **experiential** — quality is judged by looking: UI feel, interaction flow, hierarchy, animation, empty/error states, or user-facing copy.

Record the seams and classification in Implementation Notes, then follow the TDD skill one tracer bullet at a time.

Sol owns integration, behavioral work, debugging, and every final decision. Delegate only bounded leaves:

- **Luna xhigh** via `codex-run.sh luna-xhigh` for repetitive mechanical implementation, extraction, normalization, inventories, or parallel analysis whose result has an explicit test or inspection. Sol checks and integrates every Luna result; ambiguity or factual synthesis escalates back to Sol.
- **Fable medium** via `claude-run.sh fable-medium` for ordinary experiential seams; use **Fable high** when the spec marks the surface taste-critical or consequential. Fable may not change an approved decision.

Visual verification stays with Sol. Run every experiential seam live through the appropriate browser, computer, screenshot, or rendered-artifact path and check it against its acceptance criteria.

Log forced deviations under `Deviations`, mark the ticket complete where it lives, recompute the frontier, and continue. Done only when every ticket is complete and every acceptance criterion has a passing check.

## 3. Run the gauntlet

Apply the gauntlet once to the complete diff against the pinned starting commit. The normal reviewer is Fable medium; high blast radius uses Fable high. Sol applies minimal fixes and the same Fable profile performs each delta check. Done when the gauntlet terminates cleanly or its bounded surviving findings are recorded for the debrief.

## 4. Debrief

Apply the debrief skill to the full run, passing the pinned commit, completed spec, Implementation Notes, auto-fix log, and any one-way doors needing a ruling. Nothing merges until the user has read the report and ruled on every open item.

## 5. Close out

After the gate, align ticket state, map entries, specs, and ADRs with reality. Do not commit, merge, publish, deploy, send messages, or perform any other irreversible action without the user's explicit approval. Done when every tracked artifact agrees with the verified result.

## One-way doors mid-run

Take the most conservative reversible path and log it. If none exists, stop with a decision packet: the question, options, evidence, and what each option forecloses.
