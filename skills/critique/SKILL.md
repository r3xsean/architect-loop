---
name: critique
description: Critique of a non-code deliverable since a fixed starting point — Craft (does it meet the rubric, style guide, or reference works?) and Brief (does it deliver what the spec asked?), plus a Domain-risk axis for regulated or brand-critical content. Runs the axes in parallel, always cross-model, and reports them side by side; the maker then applies the findings automatically. Use when the produce skill reaches its review step, or the user asks to critique a draft, document, deck, video, or design.
---

Two-axis critique of a deliverable against the fixed starting point the caller supplies:

- **Craft** — does the work meet its domain's quality bar?
- **Brief** — does the work faithfully deliver what the originating spec asked?

Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings. Reviewers get the brief and the material — never the maker's narrative about it.

Every critique runs **cross-model**: the axes go to the other model family than the maker's — via the `codex` skill wrapper (`~/.claude/skills/codex/codex-run.sh`, one background run per axis) when Claude made the work, Claude sub-agents when Codex did. When the caller asks, or the deliverable carries domain risk (regulated, legal, medical, financial claims, or brand-critical launches), add the **Domain-risk** axis (prompt in step 4).

## Process

### 1. Pin the fixed point

Whatever the caller supplied — a snapshot, a prior version, an empty starting state. Identify exactly what changed since it: the material under critique.

### 2. Identify the brief source

The spec, plan, or ticket the work was made against. If none is found, ask the caller where it is; if there isn't one, the Brief sub-agent skips and reports "no brief available".

### 3. Identify the craft sources

In order of authority:

1. The rubric recorded for this work (e.g. in implementation-notes.md).
2. Any documented style guide, voice guide, or design system the project keeps.
3. **Reference works the user pointed at.** When the domain is one nobody involved has vocabulary for, the references *are* the quality bar — critique by comparison against them ("do the cuts breathe like the reference's do?"), never against an unwritten rubric.

A documented source always beats general taste; general taste is a judgement call, never a hard violation.

### 4. Spawn all axes in parallel

Launch one reviewer per axis — Craft, Brief, and Domain-risk when it applies — through the cross-model mechanism above. Claude reviewers are pinned `model: opus`, never inherited.

**Craft sub-agent prompt** — include the changed material, the craft sources from step 3 in full, and the brief: "Report every place the work falls short of a craft source: cite the source (rubric line, guide rule, or the reference and what it does differently). Distinguish hard violations of documented sources from judgement calls. Under 400 words."

**Brief sub-agent prompt** — include the changed material, the brief source, and the brief: "Report: (a) things the spec asked for that are missing or partial; (b) things in the work that weren't asked for (scope creep); (c) things that look delivered but look wrong. Quote the spec line for each finding. Under 400 words."

**Domain-risk axis prompt** (when it applies) — include the changed material and the brief: "Assume the work delivers its brief well. Report only what it could get wrong in ways that harm a reader who acts on it: factual or regulated claims stated without support, missing disclaimers or consent language, misleading precision, advice outside the deliverable's authority. Quote each passage. Under 400 words."

### 5. Apply

Findings are fixed automatically, not reported for the caller to chase: hand them to the maker to revise — revisions minimal, addressing only the finding — then re-run the axes that had findings against the revision, once. Escalate to the caller only a finding whose fix would change something they approved — a taste pick, a brief requirement, any caller-approved decision — or that survives the revision. Log what changed.

### 6. Aggregate

Present the final run's reports under `## Craft`, `## Brief`, and (when run) `## Domain-risk` headings, verbatim or lightly cleaned. Do **not** merge or rerank findings across axes. Open with maker model, reviewer model, and the revision log. End with a one-line summary: total findings per axis, surviving findings escalated, and the worst issue within each.

## Why two axes

A deliverable can pass one axis and fail the other: beautifully made work that delivers the wrong thing (Craft pass, Brief fail), or exactly-what-was-asked work that is badly made (Brief pass, Craft fail). Reporting them separately stops one axis from masking the other.
