---
name: blueprint
description: Blueprint a decided piece of work — a decisions-first HTML plan to approve, then spec and tickets in one motion. Use when the architect skill's interview completes, or the user asks to blueprint, plan out, or spec-and-ticket work whose decisions are already made.
---

Run this in the same **Claude Fable high** session after the deciding and Sol challenge are done. Input: resolved decisions and a Decisions Log (from the architect skill, a grilling, or a worked wayfinder map).

Steps 2 and 3 follow the processes documented in the sibling `to-spec` and `to-tickets` skills — read their SKILL.md files and apply them. One adaptation: their user-confirmation points (to-spec's seam check, to-tickets' breakdown quiz) are satisfied by the plan approval in step 1 — never re-asked. When the work isn't code, apply their shapes generally: the spec is the brief, decided; seams become acceptance criteria; tickets stay vertical slices of the deliverable (a lesson teachable, a section readable — never a layer across all of it).

## 1. The plan

One HTML file, opened for the user:

- **Top**: every one-way door decision, each with the alternatives rejected and why.
- **Middle**: any unresolved taste question as embedded side-by-side variants to pick from; the seams the feature will be tested at (per to-spec's seam rules — highest and fewest possible); the proposed ticket breakdown with its blocking edges (per to-tickets' vertical-slice rules); and the **blast radius** call — `low`, `medium`, or `high` (high when the work touches auth, money, user data, destructive actions, or external side effects). At medium or high, also an **acceptance contract**: invariants and anti-requirements in plain language ("X never happens; data never leaves Y; p95 stays under N"). Both carry into the spec — the review skills read them from there.
- **Bottom, collapsed**: the mechanical churn — refactors, naming, file layout — labelled "trusted to the execution session", with the Decisions Log.

Before opening the plan, send the proposed seams, ticket graph, blast radius, and acceptance contract to Codex via `codex-run.sh sol-medium`. Ask for feasibility and completeness gaps only. Repair mechanical gaps directly; anything that would change a resolved decision returns to the user as an explicit plan revision.

The user reviews the top and middle. Revise until they approve; approval gates everything below and stands as the seam and breakdown confirmations.

## 2. Spec

Follow the `to-spec` skill: synthesize the conversation and approved plan into its spec template — no new interview; the deciding already happened and the seams were approved at step 1. Publish it wherever this project keeps specs (default: `docs/specs/`).

## 3. Tickets

Follow the `to-tickets` skill: the approved breakdown from step 1, published per its templates with blocking edges — written into the spec file itself as a closing `## Tickets` section, never a separate tickets file (a real issue tracker, when configured, still gets native issues). Done when every spec requirement is covered by exactly one ticket.

## 4. Handoff

Emit a ready-to-paste prompt for a fresh execution session, naming the spec by path (never the plan — its content is already folded into the spec), instructing it to complete the whole spec ticket by ticket — never just the first ticket. Keep the prompt to 2–3 sentences; the spec holds the decisions and ticket graph.

- Code and long-running implementation run in a fresh **GPT-5.6 Sol xhigh** session via `execute`.
- Checkable documents, decks, spreadsheets, rendered artifacts, and tool-heavy deliverables run on Sol via `produce` (`sol-medium`, or `sol-xhigh` when hard or high-risk).
- Prose, positioning, and taste-led deliverables run on Fable via `produce` (`fable-medium`, or `fable-high` when consequential).

Stop: execution belongs to the fresh routed session.
