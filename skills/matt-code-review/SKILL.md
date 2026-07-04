---
name: matt-code-review
description: Review the changes since a fixed point (commit, branch, tag, or merge-base) along blast-radius-scaled axes — Standards (does the code follow this repo's documented coding standards?), Spec (does the code match what the originating issue/PRD/acceptance contract asked for?), and at high blast radius Tail (does it do anything extra — data egress, auth boundaries, destructive paths?). Every axis runs cross-model in parallel; findings are auto-fixed and re-reviewed at every radius. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X".
---

Review of the diff between `HEAD` and a fixed point the user supplies, along axes scaled by **blast radius**:

- **Standards** — does the code conform to this repo's documented coding standards?
- **Spec** — does the code faithfully implement the originating issue / PRD / acceptance contract?
- **Tail** (high blast radius only) — does the code do the right thing *plus something extra*?

Axes run as **parallel reviewers** so they don't pollute each other's context, then this skill aggregates their findings. Reviewers get the spec and the diff — never the builder's implementation notes or self-reported summary: the generator must not grade its own work.

The issue tracker should have been provided to you — run `/setup-matt-pocock-skills` if `docs/agents/issue-tracker.md` is missing.

## Process

### 1. Pin the fixed point

Whatever the user said is the fixed point — a commit SHA, branch name, tag, `main`, `HEAD~5`, etc. If they didn't specify one, ask for it.

Capture the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Also note the list of commits via `git log <fixed-point>..HEAD --oneline`.

Before going further, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here — not inside two parallel sub-agents.

### 2. Read the blast radius

The blueprint records it in the spec (`low` / `medium` / `high`). If no spec or no field, infer: **high** when the diff touches auth, money, user data, destructive actions, or external side effects; otherwise **low** — and state the inference in one line so the user can override.

Every review runs **cross-model**: the axis prompts go to the other model family than the one that wrote the diff — a Claude-built diff is reviewed via the `codex` skill wrapper (`~/.claude/skills/codex/codex-run.sh`, one background run per axis, prompt on stdin); a Codex-built diff is reviewed by Claude — from a Claude session, `general-purpose` sub-agents; from a Codex session, one `~/.agents/skills/claude/claude-run.sh opus` run per axis. Reviewers get the spec, diff command output, and standards — nothing from the builder's session.

Blast radius decides only which axes run: **Standards + Spec** always; **high** adds the **Tail** axis and the contract-derived probes. Findings at every radius go through the auto-fix loop (step 6).

### 3. Identify the spec source

Look for the originating spec, in this order:

1. The **acceptance contract** from the blueprint — the human-authored invariants and anti-requirements in the spec file. When present it is the primary spec input; at high blast radius the Spec reviewer derives its own probes from it (checks the builder never saw) and runs them where practical. Probes that need a running app, a browser, or screenshots run on Codex regardless of which family reviews the axis — vision and computer use are its strength, and screenshots are token-heavy on Claude.
2. Issue references in the commit messages (`#123`, `Closes #45`, GitLab `!67`, etc.) — fetch via the workflow in `docs/agents/issue-tracker.md`.
3. A path the user passed as an argument.
4. A PRD/spec file under `docs/`, `specs/`, or `.scratch/` matching the branch name or feature.
5. If nothing is found, ask the user where the spec is. If they say there isn't one, the **Spec** sub-agent will skip and report "no spec available".

### 4. Identify the standards sources

Anything in the repo that documents how code should be written, such as `CODING_STANDARDS.md` or `CONTRIBUTING.md`.

On top of whatever the repo documents, the Standards axis always carries the **smell baseline** below — a fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing. Two rules bind it:

- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation — and, like any standard here, skip anything tooling already enforces.

Each smell reads *what it is* → *how to fix*; match it against the diff:

- **Mysterious Name** — a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code** — the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy** — a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps** — the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession** — a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches** — the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery** — one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change** — one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality** — abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains** — long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man** — a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest** — a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 5. Spawn all axes in parallel

Launch every axis the blast radius calls for at once, through the cross-model mechanism from step 2 — one background `codex-run.sh` run per axis for a Claude-built diff; for a Codex-built one, one Claude reviewer per axis (`Agent` tool, `general-purpose` subagent, `model: opus` — or `claude-run.sh opus` when the runner is Codex). Reviewer models are pinned, never inherited — reviewer quality must not depend on what model the session happens to run.

**Standards axis prompt** — include:

- The full diff command and commit list.
- The list of standards-source files you found in step 4, **plus the smell baseline from step 4** pasted in full — the reviewer has no other access to it.
- The brief: "Report — per file/hunk where relevant — (a) every place the diff violates a documented standard: cite the standard (file + the rule); and (b) any baseline smell you spot: name it and quote the hunk. Distinguish hard violations from judgement calls — documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Skip anything tooling enforces. Under 400 words."

**Spec axis prompt** — include:

- The diff command and commit list.
- The path or fetched contents of the spec, with the acceptance contract (when present) marked as primary.
- The brief: "Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong; (d) each acceptance-contract invariant, with a verdict — held, violated, or unverifiable from the diff; at high blast radius, derive and run probes for the invariants, reporting each probe's command, result, and — if unrun — why. Quote the spec line for each finding. Under 400 words."

**Tail axis prompt** (high blast radius only) — include:

- The diff command and commit list, plus the acceptance contract's anti-requirements.
- The brief: "Assume the code does what the spec asked. Report only what it does *besides* that: data leaving the system (network calls, analytics, telemetry); what gets logged and whether it includes secrets or personal data; auth/tenant boundaries — any query or path that can cross them; destructive-action paths and their guards; new or changed dependencies and their risk; background jobs and persistence side effects. For each: quote the hunk, state who is affected and how it stays invisible to a happy-path user. Under 400 words."

If the spec is missing, skip the Spec axis and note this in the final report.

### 6. Auto-fix loop

Findings are fixed automatically, not reported for the user to chase: hand them to the builder model to fix, then re-run the axes that had findings, cross-model, against the new diff. Up to three rounds. Fixes must be minimal — address only the finding; a fix may not broaden scope, add features, or alter approved plan decisions (escalate instead). Judgement-call findings (baseline smells) are fixed too unless the fix would enlarge the diff beyond the spec's scope — then they're logged and left.

Once all failed axes pass (or the third round ends), re-run **all** active axes once against the final diff — a Spec fix can break Standards or open a Tail — and carry that run's results into the report.

Escalate to the user only when a finding survives all three rounds, or its fix would change a decision the approved plan recorded — plan decisions belong to the user, not the builder. Log every auto-fix so the debrief covers it.

### 7. Aggregate

Present the final run's reports under `## Standards`, `## Spec`, and (when run) `## Tail` headings, verbatim or lightly cleaned. Do **not** merge or rerank findings — the axes are deliberately separate (see _Why separate axes_).

Open with a one-line **provenance** header: builder model, reviewer model(s), blast radius, and auto-fix rounds run. Follow with the auto-fix log.

End with a one-line summary: total findings per axis, surviving findings escalated, and the worst issue _within each axis_ (if any). Don't pick a single winner across axes — that's the reranking the separation exists to prevent.

## Why separate axes

A change can pass one axis and fail the others:

- Code that follows every standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions → **Spec pass, Standards fail.**
- Code that does exactly what was asked, cleanly, *plus something extra* → **Standards pass, Spec pass, Tail fail.**

Reporting them separately stops one axis from masking another.
