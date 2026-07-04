---
name: architect
description: Turn a raw intent into resolved architectural decisions — the user decides the one-way doors, Claude decides and logs the churn.
disable-model-invocation: true
---

The user has said what they want — code or not: a feature, a course, a video, a document. Their job is the **one-way doors** — decisions expensive to reverse: data models, interfaces, UX flows, security boundaries, or their domain's equivalents (structure, voice, visual style, what gets cut). Every two-way door is yours: decide it conservatively, record it in a running **Decisions Log**, never ask.

If this machine has mattpocock/skills installed, reach for its `grilling`, `research`, and `prototype` skills where the steps below name those activities.

## 1. Blindspot pass (silent)

Explore the territory — the codebase or the materials — and the intent relentlessly: enumerate every unknown the work will run into, including the unknown unknowns the user wouldn't think to ask about. Sort each one — one-way door into the **decision queue**, two-way door into the Decisions Log. Do not show the user the raw unknown list. Done when every unknown found is either queued or logged — none unsorted.

## 2. Mode checkpoint

Present the shape of the queue: how many questions are answerable now, how many are blocked on legwork (research or prototypes must land first), how many depend on each other's answers, and whether there is **fog** — decisions sensed but not yet phrasable. Recommend a mode with that reasoning, and wait for the user's choice:

- **Grilling** — every question answerable by the user, now, in one sitting.
- **Wayfinder** — any question blocked on legwork, any fog, or resolution won't fit one session.

## 3a. Grilling mode

- Fact questions: dispatch background subagents to read primary sources only — official docs, source code, specs, never a secondary write-up — each returning a cited markdown file. Never block the interview on them; fold returning findings into later questions.
- Taste questions ("I'll know it when I see it"): build one throwaway HTML file of 3–4 wildly different variants for the user to react to.
- Interview one question at a time, highest blast radius first. No cap on count: done only when the decision queue is empty.

Then invoke the blueprint skill.

## 3b. Wayfinder mode

Charting the map is its own session's work. Produce a charting brief — notes, the queue as candidate tickets typed `research` / `prototype` / `grilling` / `task` with their blocking edges, the fog sketch — and hand the user off to /wayfinder with it. Stop.
