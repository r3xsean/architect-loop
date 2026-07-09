# architect-loop

An agent-portable skill set that compresses a full engineering workflow down to **four human touchpoints — all judgment, zero process management**. You make the architectural decisions (the one-way doors); the agents handle the mechanical churn and log every call they make on your behalf.

```
/architect <intent>     → 👤 say where you're starting from → blindspot digest teaches you
                          the territory → 👤 pick mode (with a recommendation) → 👤 answer
                          the interview → Sol challenge                            [Fable high]
blueprint  (auto)       → 👤 approve the top of one HTML page                     [Fable high]
execute <spec>          → code: complete every ticket → gauntlet                   [Sol xhigh]
/produce <spec>         → non-code: rubric-first → cross-family critique       [Fable or Sol]
debrief    (auto)       → 👤 read the report + rule on open items   ← the merge/publish gate
close out  (auto)
```

The loop is domain-agnostic — a feature, a course, a video, a document. Everything upstream (architect, blueprint, debrief) is shared; only the execution lane splits.

The organizing idea comes from Thariq (@trq212): agents do bad work when they have to **guess**, and every guess traces back to an unanswered question — an *unknown*. The loop finds the questions cheaply (before wrong guesses get expensive), routes each kind of question to the right tool, and gates the merge on you actually understanding what was built. And it works both directions: the blindspot pass doesn't just convert *your* unknown unknowns into questions Claude asks — it surfaces a **digest** that teaches them back to you (the traps, the quality bars you may not know exist, the vocabulary you'll need), so the person answering the one-way doors is calibrated before the first question lands.

## Two primary sessions, one loop

The normal code path has two primary sessions: **Claude Fable high** runs `architect → blueprint`; after plan approval, a fresh **GPT-5.6 Sol xhigh** session runs the complete spec through `execute → gauntlet → debrief → close-out`. Each delegates bounded work without giving up ownership.

**Division of labor.** Fable decides: architecture, one-way doors, taste, writing, and review. Sol reasons and executes: implementation, research, debugging, artifacts, browser/computer work, and aggregation. Luna xhigh handles bounded checked leaves — mechanical implementation, extraction, classification, normalization, inventories, summaries, and parallel analysis — whose output Sol checks. Humans approve irreversible actions.

**Cross-family verification, always.** The generator never grades its own work. Sol- or Luna-made work is reviewed by Fable medium, or Fable high when consequential or taste-critical. Fable-made work is reviewed by Sol medium, or Sol xhigh when consequential. Reviewers get the acceptance contract, sources, and actual diff or artifact — never the builder's Implementation Notes.

**Delegation inside the build.** `execute` classifies every seam as mechanical, behavioral, or experiential. Sol owns integration and delegates only bounded leaves: Luna xhigh handles checked mechanical work; Fable medium handles ordinary experiential seams and Fable high handles taste-critical ones. Visual verification flows back to Sol: screenshots, browser walks, rendered states, and interaction checks are inspected live by the execution session.

**Auto-fix, scaled by blast radius.** The blueprint records a **blast radius** (`low`/`medium`/`high` — high when work touches auth, money, user data, destructive actions, or external side effects) and, at medium+, a human-authored **acceptance contract**: invariants and anti-requirements in plain language ("X never happens; data never leaves Y"). Review always runs Standards + Spec; high adds a **Tail** axis — does the code do the right thing *plus something extra* (data egress, secret logging, tenant-boundary crossings)? — and contract-derived probes the builder never saw. Findings at every radius are auto-fixed by the builder and verified cross-model with **delta checks** — the re-reviewer sees the findings plus the fix's own diff and answers one question: resolved, without introducing anything new? — up to three rounds. Only at high radius do all axes re-sweep the final diff (a Spec fix can break Standards or open a Tail). The human is pulled in for exactly two things: a finding that survives all rounds, or a fix that would change an approved plan decision.

The result is a zero-touch happy path — build → cross-model review → auto-fix → re-verify → debrief — with human judgment concentrated at blueprint approval and genuine escalations only.

## The skills

### Shared skills (`skills/` → both agents)

Skills written for this loop follow the principles in Matt Pocock's [`writing-great-skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-great-skills) (user- vs model-invocation, leading words, checkable completion criteria, progressive disclosure):

| Skill | Invocation | What it does |
|---|---|---|
| **architect** | user | Fable-high entry point: starting-point calibration, blindspot digest, divergence, grilling/wayfinder, Sol-routed research, then a Sol-xhigh assumption challenge before Blueprint. |
| **blueprint** | model | Decisions-first HTML plan, Sol-medium feasibility check, blast radius and acceptance contract, then spec and tickets in one motion. Approval emits the routed fresh-session handoff. |
| **produce** | user | Shared non-code lane: Fable makes prose/taste work; Sol makes checkable artifacts. Drafts rubric-first, critiques through the opposite family, then debriefs. |
| **critique** | model | gauntlet's non-code analog, **always cross-model**: parallel axes, never merged — **Craft** (rubric, style guide, or the reference works you pointed at) and **Brief** (spec fidelity: missing, scope-crept, or wrong), plus a **Domain-risk** axis for regulated or brand-critical content. Findings are applied by the maker automatically and re-critiqued; only caller-approved decisions escalate. |
| **gauntlet** | model | Blast-radius-scaled, **always cross-model** review: **Standards** (repo conventions + a Fowler smell baseline), **Spec** (issue/PRD/acceptance contract, with contract-derived probes at high radius), and at high radius **Tail** ("does it do anything extra?" — data egress, auth boundaries, destructive paths). Auto-fix loop at every radius; reviewer models pinned, never inherited. |
| **debrief** | model | Thariq's post-implementation pattern, shared by both lanes: one HTML report — context and intuition first, work mapped per acceptance criterion, deviations verbatim, a "needs your ruling" queue. **Nothing merges or publishes until you've read it and ruled on every open item.** Optional pitch/buy-in extension in `PITCH.md`. |
| **codex** | model | GPT plumbing with three YOLO profiles: `sol-medium`, `sol-xhigh`, and `luna-xhigh`, with resumable threads. |

### Codex side (`agents-skills/` → `~/.agents/skills/`)

| Skill | What it does |
|---|---|
| **execute** | Sol-xhigh whole-spec code lane: pins one starting commit, works every ticket on the frontier with TDD, delegates checked leaves to Luna and experiential seams to Fable, runs one final cross-family gauntlet, then debriefs. |
| **claude** | Fable plumbing with YOLO `fable-medium` and `fable-high` profiles and resumable sessions. |

### Vendored from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT)

The skills the orchestrators lean on, copied as-is except where noted:

`grilling` · `domain-modeling` · `research` · `prototype` · `to-spec` (renamed) · `to-tickets` (renamed) · `wayfinder` · `tdd` (modified) · `gauntlet` (was code-review; substantially reworked — see above)

**Modifications, specifically:**

1. **`tdd`** — the seam-confirmation step is artifact-first: when a ticket/spec/plan exists, seams under test are *derived from its acceptance criteria* and recorded in the spec's `## Implementation Notes` section instead of asked. The question survives only as a fallback when no artifact answers — which keeps `execute` fully automatic without losing the pre-agreed-seams discipline.
2. **`code-review` → `gauntlet`** — first renamed (to `matt-code-review`) to avoid shadowing Claude Code's built-in `/code-review`, then reworked into the cross-model, blast-radius-scaled, auto-fixing review described above and renamed to match what it became. Matt's two-axis skeleton (Standards/Spec, parallel and never merged) survives at its core.
3. **`to-spec` / `to-tickets`** — vendored from [mattpocock/skills#410](https://github.com/mattpocock/skills/pull/410). `to-tickets` now publishes tickets *into the source spec file* as a closing `## Tickets` section (one document, two passes — spec-writing and ticket-slicing stay separate acts so slicing pressure can't contaminate the spec, but there's no second file to track); `tickets.md` survives only as a fallback when no spec exists. The spec similarly accrues a `## Implementation Notes` section from executing sessions (seams, rubrics, deviations, conservative calls) — the spec is the single document the whole loop reads and writes; there is no separate implementation-notes.md to track or leak.
4. **`research`** — Sol owns primary-source synthesis; Luna may handle checked extraction leaves.

Everything is plain markdown + HTML artifacts + file-based specs and tickets, and the cross-model calls are two small shell wrappers — so the loop ports to any pair of coding agents that read skills.

## Install

Run the idempotent installer; shared skills go to both agents and agent-specific skills overlay them:

```sh
./install.sh
```

Then start any piece of work with `/architect <what you want>` in Claude Code.

Requires both CLIs installed and authenticated (`claude`, `codex`) — each side shells out to the other for cross-model review and delegation. Optional: run Matt's `setup-matt-pocock-skills` (from his repo) to put wayfinder maps and tickets on a real tracker (GitHub/Linear); without it, everything defaults to local markdown files.

## Credits

This is an integration of two people's public work — the ideas are theirs, the wiring is mine:

- **[Thariq (@trq212)](https://x.com/trq212)** — the unknowns framework and the artifact patterns this loop operationalizes:
  - [*A Field Guide to Fable: Finding Your Unknowns*](https://x.com/trq212/article/2073100352921215386) — known/unknown quadrants, blindspot passes, interviews, references, decisions-first plans, implementation notes, quizzes
  - [*Using Claude Code: The Unreasonable Effectiveness of HTML*](https://x.com/trq212/status/2052809885763747935) — why every reviewable artifact here is HTML
  - [Companion artifact examples](https://thariqs.github.io/html-effectiveness/unknowns/)
- **[Matt Pocock (@mattpocockuk)](https://x.com/mattpocockuk)** — [mattpocock/skills](https://github.com/mattpocock/skills) ("Skills for Real Engineers"), which supplies the vendored skills, the wayfinder mapping model, and the [`writing-great-skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-great-skills) principles the loop's skills were written against.

The cross-model verification design (generator never grades its own work, blast-radius scaling, Tail axis, auto-fix loops, taste delegation) was worked out in a running Claude ↔ Codex debate — both models signed off on the final shape.

Vendored skills remain © Matt Pocock under MIT — see [LICENSE-mattpocock-skills](LICENSE-mattpocock-skills).
