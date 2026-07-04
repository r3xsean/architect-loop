---
name: produce
description: Take one ticket of non-code work from grabbed to publish-ready, fully automatic — draft rubric-first, critique until clean, debrief. The user's first touchpoint is the final HTML.
disable-model-invocation: true
---

The non-code lane of the loop — documents, courses, videos, decks, designs, anything whose territory isn't a codebase. Runs in a fresh session, one ticket at a time. Input: the ticket, plus the spec and plan it came from. **Fully automatic: never stop to ask.** Every judgment call gets the conservative choice, logged in `implementation-notes.md`; anything that needs the user's ruling is surfaced in the debrief, never mid-run.

## 1. Pin the territory

Read the ticket, the spec, the plan, and any prior implementation-notes. Snapshot the deliverable's current state — the fixed point every later comparison and critique runs against. Restate the ticket's acceptance criteria as a checkable list. Done when every criterion is one the finished work can be checked against, not a vibe.

## 2. Draft, rubric first

Before drafting each slice, write the rubric that slice must satisfy — derived from the plan and acceptance criteria, recorded in implementation-notes.md **before the work it measures exists**. Then draft to it, one vertical slice at a time: each slice a complete, reviewable piece of the deliverable, never a layer across all of it. Log every forced deviation from the plan under "Deviations" with the conservative call made. Done when every acceptance criterion is met per its rubric — not when the draft feels finished.

## 3. Critique until clean

Invoke the `critique` skill against the pinned state. Apply the findings; a finding that contradicts the spec is a one-way door — take the conservative side and log it for the debrief, never absorb it silently. Re-critique after fixing. Done only when a full pass returns zero new findings.

## 4. Debrief

Invoke the `debrief` skill, passing the pinned state, implementation-notes.md, and the spec, with the logged one-way doors as its "needs your ruling" items. Its quiz is the publish gate: nothing ships until the user passes it and has ruled on every open item.

## 5. Close out

Mark the ticket done where it lives, link the artifacts from it, and fold any deviation that invalidates a plan decision, map entry, or ADR back into that document. Done when the tracker, the map, and the docs all agree with reality.
