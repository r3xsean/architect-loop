---
name: produce
description: Produce an approved non-code spec to publish-ready — route prose and taste work to Fable, checkable artifacts to Sol, draft rubric-first, critique cross-family until clean, then debrief.
disable-model-invocation: true
---

The non-code lane uses the same procedure on either family. Route by the hard part:

- **Fable medium** for routine prose, writing, and taste-led composition; **Fable high** for public positioning, consequential writing, or taste-critical work.
- **Sol medium** for documents, decks, spreadsheets, rendered artifacts, browser/computer work, and other checkable production; **Sol xhigh** when ambiguous, long-running, high-risk, or expensive to recover.

Input is the approved spec and its tickets; the plan has already been folded into the spec. **Fully automatic: never stop to ask.** Log conservative calls in the spec's `## Implementation Notes` section and surface genuine one-way doors in the debrief.

## 1. Pin the territory

Read the complete spec, its tickets, and existing Implementation Notes. Record the maker family/profile, snapshot the deliverable's current state, and resolve the ticket frontier. Restate the current ticket's acceptance criteria as a checkable list. Done when every criterion can be checked against the finished work, not a vibe.

## 2. Draft, rubric first

Before drafting each slice, write the rubric that slice must satisfy — derived from the plan and acceptance criteria, recorded in the spec's `## Implementation Notes` **before the work it measures exists**. Then draft to it, one vertical slice at a time: each slice a complete, reviewable piece of the deliverable, never a layer across all of it. Log every forced deviation from the plan under "Deviations" with the conservative call made. Done when every acceptance criterion is met per its rubric — not when the draft feels finished.

## 3. Critique until clean

Invoke the `critique` skill against the pinned state and pass the maker profile. It selects the opposite-family reviewer. Apply the findings; a finding that contradicts the spec is a one-way door — take the conservative side and log it for the debrief, never absorb it silently. Re-critique after fixing. Done only when a full pass returns zero new findings.

## 4. Debrief

Invoke the `debrief` skill, passing the pinned state and the spec (its Implementation Notes included), with the logged one-way doors as its "needs your ruling" items. Its report is the publish gate: nothing ships until the user has read it and ruled on every open item.

## 5. Close out

Mark the ticket done where it lives, link the artifacts from it, and fold any deviation that invalidates a plan decision, map entry, or ADR back into that document. Done when the tracker, the map, and the docs all agree with reality.
