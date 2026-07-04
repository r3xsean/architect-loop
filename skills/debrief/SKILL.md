---
name: debrief
description: Debrief a working session into one HTML report with a quiz the user must pass before merging or publishing. Use when the execute or produce skill reaches its gate, or the user asks to be debriefed or quizzed on what changed.
---

The session did more than the user followed, and a diff can't show it — much of the behaviour depends on existing code paths. The debrief closes that gap: it converts what the agent knows about the change back into things the user knows, and proves the transfer with a quiz.

## 1. Gather

The diff against the run's fixed point, implementation-notes.md, the spec the work was built against, and any "needs your ruling" items handed in.

## 2. The report

One HTML file, opened for the user:

- **Context and intuition first** — why the change works, not just what changed, including the existing code paths its behaviour depends on.
- **What was done**, mapped per acceptance criterion.
- **Deviations**, verbatim from implementation-notes.md.
- **Needs your ruling** — every decision the run took conservatively that the user must confirm or reverse.
- **A quiz at the bottom** the user must pass perfectly; each wrong answer points back to the exact section skimmed.

Done when the user reports a perfect score and has ruled on every open item — this is the merge gate; a near-perfect score does not open it.

If the user wants buy-in material for reviewers or leadership, extend the report per [PITCH.md](PITCH.md).
