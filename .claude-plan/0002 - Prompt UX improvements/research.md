# Research: 0002 - Prompt UX Improvements

## What exists

### `/research` skill — `.claude/commands/research.md`

Full file, 33 lines. The relevant steps:

- **Step 5** (lines 11–17): Instructs Claude to study the codebase thoroughly.
- **Step 6** (lines 18–23): Write `research.md` to disk.
- **Step 7** (line 24): `"Write a short summary of the research to the user in the chat."` — a summary step does exist, but it is phrased as a general "write to chat" instruction with no explicit constraint that it must appear as terminal output *before* the `AskUserQuestion` tool call fires.
- **Step 8** (lines 25–28): `"After writing, ask the user via AskUserQuestion"` — the "After writing" wording implies ordering, but does not explicitly prohibit Claude from bundling the summary with the tool call in the same response turn, which appears to be the observed failure mode.
- **No dependency section** in this file (not relevant to this skill).

### `/plan` skill — `.claude/commands/plan.md`

Full file, 33 lines. Relevant steps:

- **Step 5** (line 11): `"Ask 3-5 questions on the implementation if there is any uncertainty/ambiguity on how the feature should be planned."` — `AskUserQuestion` fires here, **before the plan is written**. At this point there is no artifact to summarize, so no summary requirement applies here.
- **Step 6** (lines 12–22): Write `plan.md` to disk.
- **Step 7** (line 23): `"Summarize the plan to me in the chat."` — a summary step exists.
- **Step 8** (lines 24–25): `"Ask me 3-5 questions on design choices or tough decisions you had to make while writing the plan."` — same ambiguity as `/research`: "Summarize... then ask" is implied by ordering, but the instruction does not explicitly require the summary to appear as plain terminal output before the `AskUserQuestion` call.
- **No dependency section**: nothing in the file instructs Claude to flag newly introduced packages, libraries, or external tools.

### Other skills — for context

- `implement.md`: No `AskUserQuestion` calls. Not affected.
- `new-idea.md`: Step 4 and Step 6 both use `AskUserQuestion`, but these fire at ideation time before any code artifact exists — no summary applies.
- `quick-job.md`: Single-step, no `AskUserQuestion`. Not affected.

## How it connects

These skill files are Claude Code slash-command prompts. When a user runs `/research 002` or `/plan 002`, Claude Code injects the file contents as the active instruction set. There is no middleware, pre-processing, or shared base prompt — each `.md` file is the complete contract for that skill.

`AskUserQuestion` is a tool call. Tool calls and plain text output can coexist in a single response turn. The ambiguity in the current prompts allows Claude to emit the summary and fire the `AskUserQuestion` call in the same turn, which may cause the UI to show the question box before or alongside the summary text, making the context invisible unless the user scrolls.

## Constraints

- These are pure markdown prompt files — no code, no build step, no tests.
- Changes must be phrased as natural-language instructions that Claude follows reliably.
- The instruction must be unambiguous about ordering: summary first, tool call second.
- The dependency warning in `/plan` must be scoped to cases where new packages are actually introduced — an unconditional warning section would create noise for plans that add no dependencies.

## Risks

- **Over-specification**: Making the summary instruction too prescriptive (e.g., requiring specific format) may conflict with Claude's natural output style and cause it to generate formulaic summaries. A light, behaviour-shaping instruction is safer.
- **Step 5 in `/plan`**: The pre-plan `AskUserQuestion` (clarifying questions before writing the plan) is intentionally before any summary — changing this by accident would break the skill's intent. Only steps 7/8 in `/plan` need the summary-before-question constraint.
- **Dependency callout scope**: If the instruction says "always include a Dependencies section," Claude may add an empty or "N/A" section to every plan. The instruction should condition on whether new dependencies are actually introduced.

## Key files

| File | Change needed |
|------|--------------|
| `.claude/commands/research.md` | Strengthen step 7/8 to explicitly require plain terminal output before the `AskUserQuestion` call |
| `.claude/commands/plan.md` | (1) Same fix for steps 7/8 ordering; (2) Add instruction to flag new dependencies with a visible callout |
