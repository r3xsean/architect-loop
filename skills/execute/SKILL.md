---
name: execute
description: Take one ticket from grabbed to merge-ready, fully automatic — build, review until clean, debrief. The user's first touchpoint is the final HTML.
disable-model-invocation: true
---

Runs in a fresh session, one ticket at a time. Input: the ticket, plus the spec and plan it came from. **Fully automatic: never stop to ask.** Every judgment call gets the conservative choice, logged in `implementation-notes.md`; anything that needs the user's ruling is surfaced in the debrief, never mid-run.

## 1. Pin the territory

Read the ticket, the spec, the plan, and any prior implementation-notes. Pin the starting commit — the fixed point every later diff and review runs against. Restate the ticket's acceptance criteria as a checkable list and derive the seams under test from them, recording both in implementation-notes.md. Done when every acceptance criterion has a seam.

## 2. Build

Follow the `tdd` skill, one tracer bullet at a time, seams from step 1. Log every forced deviation from the plan under "Deviations" with the conservative call made. Done when every acceptance criterion has a passing test — not when the feature feels finished.

## 3. Review until clean

Invoke the `matt-code-review` skill against the pinned commit. Apply the findings; a finding that contradicts the spec is a one-way door — take the conservative side and log it for the debrief, never absorb it silently. Re-review after fixing. Done only when a full pass returns zero new findings.

## 4. Debrief

Invoke the `debrief` skill, passing the pinned commit, implementation-notes.md, and the spec, with the logged one-way doors as its "needs your ruling" items. Its quiz is the merge gate: nothing merges until the user passes it and has ruled on every open item.

## 5. Close out

Mark the ticket done where it lives, link the artifacts from it, and fold any deviation that invalidates a plan decision, map entry, or ADR back into that document. Done when the tracker, the map, and the docs all agree with reality.
