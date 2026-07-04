---
name: execute
description: Take one code ticket from grabbed to merge-ready, fully automatic — build with TDD, delegate taste seams to Claude, review cross-model until clean, debrief. Use when asked to execute, implement, or build a ticket from a spec/plan.
---

Runs in a fresh Codex session, one ticket at a time. Input: the ticket, plus the spec and plan it came from. **Fully automatic: never stop to ask.** Every judgment call gets the conservative choice, logged in `implementation-notes.md`; anything that needs the user's ruling is surfaced in the debrief, never mid-run.

Shared procedure dependencies live on the Claude side as the single source of truth — read and apply them, never fork copies:

- TDD: `~/.claude/skills/tdd/SKILL.md`
- Review: `~/.claude/skills/matt-code-review/SKILL.md`
- Debrief: `~/.claude/skills/debrief/SKILL.md`
- Delegating to Claude: `~/.agents/skills/claude/SKILL.md` (wrapper: `claude-run.sh <fable|opus>`)

## 1. Pin the territory

Read the ticket, the spec, the plan, and any prior implementation-notes. Pin the starting commit — the fixed point every later diff and review runs against. Restate the ticket's acceptance criteria as a checkable list, derive the seams under test from them, and classify each seam:

- **mechanical** — correctness is checkable by tests alone (data model, API, persistence, auth mechanics, infra, wiring)
- **behavioral** — checkable by tests plus the acceptance contract
- **experiential** — quality is judged by looking at it: UI look/feel, interaction flow, visual hierarchy, animation timing, empty/error states, user-facing copy

Record all of it in implementation-notes.md. Done when every acceptance criterion has a classified seam.

## 2. Build

Follow the TDD skill, one tracer bullet at a time, seams from step 1. Build mechanical and behavioral seams yourself.

**Delegate experiential seams to Claude** via the claude skill — `opus` by default, `fable` when the ticket or plan marks the surface taste-critical. Split full-stack slices at the boundary: you build the mechanics and tests, Claude builds the visible surface. Plumbing that merely feeds the UI is yours — never delegate CSS-adjacent backend. Claude's delegation prompt carries the spec, the plan's decisions, and the seam's acceptance criteria; Claude may not change approved plan decisions — if its taste solution requires that, log it as a one-way door instead of absorbing it.

Log every forced deviation from the plan under "Deviations" with the conservative call made. Done when every acceptance criterion has a passing test — not when the feature feels finished.

## 3. Review until clean

Apply the review skill against the pinned commit. You are the builder, so the cross-model rule sends every axis to Claude: one `claude-run.sh opus` run per axis, prompts and inputs exactly as the review skill specifies. The auto-fix loop stays with you. A finding that contradicts the spec is a one-way door — take the conservative side and log it for the debrief, never absorb it silently. Done only when a full pass returns zero new findings.

## 4. Debrief

Apply the debrief skill, passing the pinned commit, implementation-notes.md, and the spec, with the logged one-way doors as its "needs your ruling" items. Its quiz is the merge gate: nothing merges until the user passes it and has ruled on every open item.

## 5. Close out

Mark the ticket done where it lives, link the artifacts from it, and fold any deviation that invalidates a plan decision, map entry, or ADR back into that document. Done when the tracker, the map, and the docs all agree with reality.

## One-way doors mid-run

Hitting a true one-way door: take the conservative reversible path and log it. If no reversible path exists, stop and leave a decision packet — the question, the options, what each forecloses — as the run's output; continuing would take a decision that belongs to the user.
