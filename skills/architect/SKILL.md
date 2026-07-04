---
name: architect
description: Turn a raw intent into resolved architectural decisions — the user decides the one-way doors, Claude decides and logs the churn.
disable-model-invocation: true
---

The user has said what they want — code or not: a feature, a course, a video, a document. Their job is the **one-way doors** — decisions expensive to reverse: data models, interfaces, UX flows, security boundaries, or their domain's equivalents (structure, voice, visual style, what gets cut). Every two-way door is yours: decide it conservatively, record it in a running **Decisions Log**, never ask.

Where the steps below name the grilling, research, prototype, or wayfinder activities, you MUST invoke the corresponding skill explicitly via the Skill tool (e.g. `Skill(skill: "grilling")`) — do not merely imitate the activity from memory.

## 1. Starting point

One question, one message, before any exploration: where is the user starting from — their experience with this problem, this codebase or material, and this domain. Record the answer in the Decisions Log. It calibrates everything below: how deep the blindspot digest goes, and whether taste questions get variants to react to or teaching first.

## 2. Blindspot pass

Explore the territory — the codebase or the materials — and the intent relentlessly: enumerate every unknown the work will run into, including the unknown unknowns the user wouldn't think to ask about. Sort each one — one-way door into the **decision queue**, two-way door into the Decisions Log. Done when every unknown found is either queued or logged — none unsorted.

Then surface a **Blindspot Digest** — never the raw unknown list. Its job is to make the user's unknown unknowns *their* known unknowns before any deciding happens: the traps ahead, quality bars they may not know exist ("do you know how good this can be?"), historical context they'd never think to ask about, and the vocabulary they'll need to judge the one-way doors coming. Depth scales with step 1 — an expert in this territory gets two lines; a newcomer gets a short explainer. The digest teaches; it does not ask anything.

## 3. Divergence check

Only when the intent names a **problem rather than a chosen approach** ("users churn after onboarding", "this video feels flat"): before extracting decisions, sketch 3–5 materially different approaches, cheapest to most ambitious, each in a few lines — enough to react to, not mini-plans. The user picks a direction (or a hybrid); that pick is the first Decisions Log entry. Skip this step entirely when the approach is already decided — don't tax settled work with brainstorming theater.

## 4. Mode checkpoint

Present the shape of the queue: how many questions are answerable now, how many are blocked on legwork (research or prototypes must land first), how many depend on each other's answers, and whether there is **fog** — decisions sensed but not yet phrasable. Recommend a mode with that reasoning, and wait for the user's choice:

- **Grilling** — every question answerable by the user, now, in one sitting.
- **Wayfinder** — any question blocked on legwork, any fog, or resolution won't fit one session.

## 5a. Grilling mode

- Fact questions: dispatch background subagents (`model: opus`, pinned — findings feed one-way doors) to read primary sources only — official docs, source code, specs, never a secondary write-up — each returning a cited markdown file. Never block the interview on them; fold returning findings into later questions.
- Taste questions ("I'll know it when I see it"): **calibrate before you show.** If step 1 says the user can judge this domain, build one throwaway HTML file of 3–4 wildly different variants for the user to react to. If they lack the vocabulary to know what good looks like, variants only produce confident wrong picks — teach the domain's quality dimensions first (a short explainer, folded into or following the digest), *then* show variants.
- The interview itself: invoke the `grilling` skill via the Skill tool and run the interview under its rules — one question at a time, highest blast radius first. No cap on count: done only when the decision queue is empty.

Then invoke the `blueprint` skill via the Skill tool.

## 5b. Wayfinder mode

Charting the map is its own session's work. Produce a charting brief — notes, the queue as candidate tickets typed `research` / `prototype` / `grilling` / `task` with their blocking edges, the fog sketch — then invoke the `wayfinder` skill via the Skill tool, passing the brief as its input. Stop after handing off.
