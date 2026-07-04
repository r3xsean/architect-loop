# architect-loop

An agent-portable skill set that compresses a full engineering workflow down to **four human touchpoints — all judgment, zero process management**. You make the architectural decisions (the one-way doors); the agents handle the mechanical churn and log every call they make on your behalf.

```
/architect <intent>     → 👤 pick mode (with a recommendation) → 👤 answer the interview   [Claude]
blueprint  (auto)       → 👤 approve the top of one HTML page                              [Claude]
execute <ticket>        → code:     fully automatic — build (tdd) → cross-model review     [Codex]
/produce <ticket>       → non-code: fully automatic — draft rubric-first → cross-model critique [Claude]
debrief    (auto)       → 👤 rule on open items + pass a quiz   ← the merge/publish gate
close out  (auto)
```

The loop is domain-agnostic — a feature, a course, a video, a document. Everything upstream (architect, blueprint, debrief) is shared; only the execution lane splits.

The organizing idea comes from Thariq (@trq212): agents do bad work when they have to **guess**, and every guess traces back to an unanswered question — an *unknown*. The loop finds the questions cheaply (before wrong guesses get expensive), routes each kind of question to the right tool, and gates the merge on you actually understanding what was built.

## Two models, one loop

The loop runs on **two model families deliberately** — Claude (Anthropic) and GPT-5.5 (OpenAI, via Codex) — split by what each is best at, and crossed wherever work gets verified.

**Division of labor.** Claude Fable owns taste and one-way doors: the architect interview, blueprint approval, non-code production, and any surface whose quality is judged by looking at it. GPT-5.5 owns implementation: it's the stronger straightforward builder, so the code lane runs on Codex. Delegated sub-agent work runs one tier down on each side (Claude Opus / gpt-5.5-xhigh) — frontier judgment where judgment is the deliverable, without frontier pricing on the churn.

**Cross-model verification, always.** The core rule: **the generator never grades its own work.** A model reviewing its own output inherits its own blind spots — the misunderstanding that produced the bug also produces the test that passes it and the quiz that hides it. So every review crosses families: Codex-built code is reviewed by Claude (Opus, pinned); Claude-made work is reviewed by GPT-5.5 (xhigh, pinned). Reviewers get the spec and the diff — never the builder's narrative about it.

**Taste delegation inside the build.** `execute` classifies every seam as *mechanical* (tests alone prove it), *behavioral* (tests + acceptance contract), or *experiential* (quality judged by looking: UI feel, interaction flow, copy, empty/error states). Codex builds the first two itself and delegates experiential seams to Claude — Opus by default, Fable when the ticket marks the surface taste-critical. Full-stack slices split at the visible boundary; plumbing that feeds the UI stays with Codex.

**Auto-fix, scaled by blast radius.** The blueprint records a **blast radius** (`low`/`medium`/`high` — high when work touches auth, money, user data, destructive actions, or external side effects) and, at medium+, a human-authored **acceptance contract**: invariants and anti-requirements in plain language ("X never happens; data never leaves Y"). Review always runs Standards + Spec; high adds a **Tail** axis — does the code do the right thing *plus something extra* (data egress, secret logging, tenant-boundary crossings)? — and contract-derived probes the builder never saw. Findings at every radius are auto-fixed by the builder and re-reviewed cross-model, up to three rounds, then all axes re-run once against the final diff. The human is pulled in for exactly two things: a finding that survives all rounds, or a fix that would change an approved plan decision.

The result is a zero-touch happy path — build → cross-model review → auto-fix → re-verify → debrief — with human judgment concentrated at blueprint approval and genuine escalations only.

## The skills

### Claude side (`skills/` → `~/.claude/skills/`)

Skills written for this loop follow the principles in Matt Pocock's [`writing-great-skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-great-skills) (user- vs model-invocation, leading words, checkable completion criteria, progressive disclosure):

| Skill | Invocation | What it does |
|---|---|---|
| **architect** | user | Entry point. Silent blindspot pass sorts every unknown: one-way doors → a decision queue for you; two-way doors → decided conservatively and logged. Then a **mode checkpoint** — recommends grilling (one sitting) vs. wayfinder (multi-session map) with its reasoning, and you choose. The interview is **uncapped**: it ends when the decision queue is empty, not at a question count. Fact research runs on background sub-agents (Opus, pinned — findings feed one-way doors). |
| **blueprint** | model | Plan → spec → tickets in one motion. A decisions-first HTML plan (one-way doors on top with rejected alternatives, mechanical churn collapsed at the bottom); the plan also carries the **blast radius** call and, at medium+, the **acceptance contract**. On approval it runs to-spec and to-tickets automatically — tickets land *inside the spec file*, never a separate tickets file — and emits the handoff: code tickets to a fresh Codex session, non-code to `/produce`. |
| **produce** | user | The non-code lane (courses, videos, documents, decks, designs) — execute's mirror, same never-stops-to-ask contract. Snapshots the deliverable's starting state, drafts **rubric-first** (the checkable bar for each slice written before the work that must meet it — tdd's red-before-green without tests), critiques via `critique` until clean, then debrief. |
| **critique** | model | matt-code-review's non-code analog, **always cross-model**: parallel axes, never merged — **Craft** (rubric, style guide, or the reference works you pointed at) and **Brief** (spec fidelity: missing, scope-crept, or wrong), plus a **Domain-risk** axis for regulated or brand-critical content. Findings are applied by the maker automatically and re-critiqued; only caller-approved decisions escalate. |
| **matt-code-review** | model | Blast-radius-scaled, **always cross-model** review: **Standards** (repo conventions + a Fowler smell baseline), **Spec** (issue/PRD/acceptance contract, with contract-derived probes at high radius), and at high radius **Tail** ("does it do anything extra?" — data egress, auth boundaries, destructive paths). Auto-fix loop at every radius; reviewer models pinned, never inherited. |
| **debrief** | model | Thariq's post-implementation pattern, shared by both lanes: one HTML report — context and intuition first, work mapped per acceptance criterion, deviations verbatim, a "needs your ruling" queue — ending in **a quiz you must pass perfectly before anything merges or publishes**. Optional pitch/buy-in extension in `PITCH.md`. |
| **codex** | model | The cross-model plumbing: runs GPT-5.5 as a subagent via `codex-run.sh` (model and xhigh effort pinned, resumable threads, prompt on stdin). Used by matt-code-review and critique to review Claude-made work, and for second opinions. |

### Codex side (`agents-skills/` → `~/.agents/skills/`)

| Skill | What it does |
|---|---|
| **execute** | The code lane, now owned by Codex: one ticket, grabbed to merge-ready, **fully automatic — it never stops to ask**. Pins the starting commit, classifies seams (mechanical / behavioral / experiential), builds test-first via the shared `tdd` skill, **delegates experiential seams to Claude** (opus default, fable when taste-critical), reviews via the shared `matt-code-review` skill — every axis reviewed by Claude Opus — then debriefs. Reads its procedure dependencies (`tdd`, `matt-code-review`, `debrief`) straight from `~/.claude/skills/` as the single source of truth: no forked copies. On a true one-way door with no reversible path, it stops with a decision packet rather than decide for you. |
| **claude** | The mirror plumbing: runs Claude as a subagent via `claude-run.sh <fable\|opus>` (effort pinned, resumable sessions). Its model picker is the taste rule in miniature: opus for execution-grade work, fable when judgment is the deliverable. |

### Vendored from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT)

The skills the orchestrators lean on, copied as-is except where noted:

`grilling` · `domain-modeling` · `research` · `prototype` · `to-spec` (renamed) · `to-tickets` (renamed) · `wayfinder` · `tdd` (modified) · `matt-code-review` (renamed, substantially reworked — see above)

**Modifications, specifically:**

1. **`tdd`** — the seam-confirmation step is artifact-first: when a ticket/spec/plan exists, seams under test are *derived from its acceptance criteria* and recorded in implementation-notes.md instead of asked. The question survives only as a fallback when no artifact answers — which keeps `execute` fully automatic without losing the pre-agreed-seams discipline.
2. **`code-review` → `matt-code-review`** — renamed to avoid shadowing Claude Code's built-in `/code-review`, then reworked into the cross-model, blast-radius-scaled, auto-fixing review described above.
3. **`to-spec` / `to-tickets`** — vendored from [mattpocock/skills#410](https://github.com/mattpocock/skills/pull/410). `to-tickets` now publishes tickets *into the source spec file* as a closing `## Tickets` section (one document, two passes — spec-writing and ticket-slicing stay separate acts so slicing pressure can't contaminate the spec, but there's no second file to track); `tickets.md` survives only as a fallback when no spec exists.
4. **`research`** — background agent pinned to Opus, never inheriting a weaker session model.

Everything is plain markdown + HTML artifacts + file-based specs and tickets, and the cross-model calls are two small shell wrappers — so the loop ports to any pair of coding agents that read skills.

## Install

Copy each side into its agent's skills directory:

```sh
# Claude side
cp -R skills/* ~/.claude/skills/

# Codex side
cp -R agents-skills/* ~/.agents/skills/
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
