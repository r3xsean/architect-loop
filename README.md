# architect-loop

An agent-portable skill set that compresses a full engineering workflow down to **four human touchpoints — all judgment, zero process management**. You make the architectural decisions (the one-way doors); the agent handles the mechanical churn and logs every call it makes on your behalf.

```
/architect <intent>     → 👤 pick mode (with a recommendation) → 👤 answer the interview
blueprint  (auto)       → 👤 approve the top of one HTML page
/execute <ticket>       → code:     fully automatic — build (tdd) → review until clean
/produce <ticket>       → non-code: fully automatic — draft rubric-first → critique until clean
debrief    (auto)       → 👤 rule on open items + pass a quiz   ← the merge/publish gate
close out  (auto)
```

The loop is domain-agnostic — a feature, a course, a video, a document. Everything upstream (architect, blueprint, debrief) is shared; only the execution lane splits.

The organizing idea comes from Thariq (@trq212): agents do bad work when they have to **guess**, and every guess traces back to an unanswered question — an *unknown*. The loop finds the questions cheaply (before wrong guesses get expensive), routes each kind of question to the right tool, and gates the merge on you actually understanding what was built.

## The skills

### What I built (`skills/architect`, `blueprint`, `execute`, `produce`, `critique`, `debrief`)

Six skills written for this loop, following the principles in Matt Pocock's [`writing-great-skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-great-skills) (user- vs model-invocation, leading words, checkable completion criteria, progressive disclosure):

| Skill | Invocation | What it does |
|---|---|---|
| **architect** | user | Entry point. Silent blindspot pass sorts every unknown: one-way doors → a decision queue for you; two-way doors → decided conservatively and logged. Then a **mode checkpoint** — recommends grilling (one sitting) vs. wayfinder (multi-session map) with its reasoning, and you choose. The interview is **uncapped**: it ends when the decision queue is empty, not at a question count. |
| **blueprint** | model | Plan → spec → tickets in one motion. A decisions-first HTML plan (one-way doors on top with rejected alternatives, mechanical churn collapsed at the bottom, "trusted to Claude"); on approval it runs to-spec and to-tickets automatically and emits the `/execute` handoff prompt. |
| **execute** | user | The code lane: one ticket, grabbed to merge-ready, **fully automatic — it never stops to ask**. Pins the starting commit, builds test-first via `tdd` (seams derived from acceptance criteria), reviews via `matt-code-review` until a pass returns zero new findings, then hands off to debrief. Judgment calls take the conservative choice and are logged for your ruling later, never raised mid-run. |
| **produce** | user | The non-code lane (courses, videos, documents, decks, designs) — execute's mirror, same never-stops-to-ask contract. Snapshots the deliverable's starting state, drafts **rubric-first** (the checkable bar for each slice written before the work that must meet it — tdd's red-before-green without tests), critiques via `critique` until clean, then debrief. |
| **critique** | model | matt-code-review's non-code analog: two parallel sub-agent axes, never merged — **Craft** (rubric, style guide, or the reference works you pointed at — when nobody has vocabulary for the domain, the references *are* the quality bar) and **Brief** (spec fidelity: missing, scope-crept, or wrong). |
| **debrief** | model | Thariq's post-implementation pattern, shared by both lanes: one HTML report — context and intuition first, work mapped per acceptance criterion, deviations verbatim, a "needs your ruling" queue — ending in **a quiz you must pass perfectly before anything merges or publishes**. Optional pitch/buy-in extension in `PITCH.md`. |

### Vendored from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT)

The nine skills the orchestrators lean on, copied as-is except where noted:

`grilling` · `domain-modeling` · `research` · `prototype` · `to-spec` (renamed) · `to-tickets` (renamed) · `wayfinder` · `tdd` (modified) · `matt-code-review` (renamed)

**Modifications, specifically:**

1. **`tdd`** — the seam-confirmation step is now artifact-first: when a ticket/spec/plan exists, seams under test are *derived from its acceptance criteria* and recorded in implementation-notes.md instead of asked. The question survives only as a fallback when no artifact answers — which makes `execute` fully automatic without losing the pre-agreed-seams discipline.
2. **`code-review` → `matt-code-review`** — renamed (folder, frontmatter, and the cross-reference in `tdd`) to avoid shadowing Claude Code's built-in `/code-review` command.
3. **`to-spec` / `to-tickets`** — vendored verbatim from the live branch of [mattpocock/skills#410](https://github.com/mattpocock/skills/pull/410) (open at vendoring time), which renames and reworks the old `to-prd`/`to-issues`. Their new user-confirmation points (seam check, breakdown quiz) aren't modified in the skills themselves — `blueprint` folds them into its single plan-approval touchpoint instead.

Everything is plain markdown + HTML artifacts + file-based specs and tickets — no harness-specific commands — so it works in Claude Code, Codex, or any coding agent that reads skills.

## Install

Copy the folders in `skills/` into your agent's skills directory:

```sh
# Claude Code
cp -R skills/* ~/.claude/skills/
```

Then start any piece of work with `/architect <what you want>`.

Optional: run Matt's `setup-matt-pocock-skills` (from his repo) to put wayfinder maps and tickets on a real tracker (GitHub/Linear); without it, everything defaults to local markdown files.

## Credits

This is an integration of two people's public work — the ideas are theirs, the wiring is mine:

- **[Thariq (@trq212)](https://x.com/trq212)** — the unknowns framework and the artifact patterns this loop operationalizes:
  - [*A Field Guide to Fable: Finding Your Unknowns*](https://x.com/trq212/article/2073100352921215386) — known/unknown quadrants, blindspot passes, interviews, references, decisions-first plans, implementation notes, quizzes
  - [*Using Claude Code: The Unreasonable Effectiveness of HTML*](https://x.com/trq212/status/2052809885763747935) — why every reviewable artifact here is HTML
  - [Companion artifact examples](https://thariqs.github.io/html-effectiveness/unknowns/)
- **[Matt Pocock (@mattpocockuk)](https://x.com/mattpocockuk)** — [mattpocock/skills](https://github.com/mattpocock/skills) ("Skills for Real Engineers"), which supplies the nine vendored skills, the wayfinder mapping model, and the [`writing-great-skills`](https://github.com/mattpocock/skills/tree/main/skills/productivity/writing-great-skills) principles the four new skills were written against.

Vendored skills remain © Matt Pocock under MIT — see [LICENSE-mattpocock-skills](LICENSE-mattpocock-skills).
