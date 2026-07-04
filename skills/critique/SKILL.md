---
name: critique
description: Two-axis critique of a non-code deliverable since a fixed starting point — Craft (does it meet the rubric, style guide, or reference works?) and Brief (does it deliver what the spec asked?). Runs both axes as parallel sub-agents and reports them side by side. Use when the produce skill reaches its review step, or the user asks to critique a draft, document, deck, video, or design.
---

Two-axis critique of a deliverable against the fixed starting point the caller supplies:

- **Craft** — does the work meet its domain's quality bar?
- **Brief** — does the work faithfully deliver what the originating spec asked?

Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings.

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

### 4. Spawn both sub-agents in parallel

Send a single message with two Agent tool calls.

**Craft sub-agent prompt** — include the changed material, the craft sources from step 3 in full, and the brief: "Report every place the work falls short of a craft source: cite the source (rubric line, guide rule, or the reference and what it does differently). Distinguish hard violations of documented sources from judgement calls. Under 400 words."

**Brief sub-agent prompt** — include the changed material, the brief source, and the brief: "Report: (a) things the spec asked for that are missing or partial; (b) things in the work that weren't asked for (scope creep); (c) things that look delivered but look wrong. Quote the spec line for each finding. Under 400 words."

### 5. Aggregate

Present the two reports under `## Craft` and `## Brief` headings, verbatim or lightly cleaned. Do **not** merge or rerank findings across axes. End with a one-line summary: total findings per axis, and the worst issue within each.

## Why two axes

A deliverable can pass one axis and fail the other: beautifully made work that delivers the wrong thing (Craft pass, Brief fail), or exactly-what-was-asked work that is badly made (Brief pass, Craft fail). Reporting them separately stops one axis from masking the other.
