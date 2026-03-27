# 0002 - Prompt UX improvements

## Initial Idea
Update skill prompts to: (1) explicitly flag when dependencies are being added in `/plan`, and (2) always print a summary before asking a question (e.g. after `/plan` or `/research`).

## Clarifying Q&A

**What problem does this solve?**
Both pain points are equally important:
- After `/plan` or `/research` completes and asks a clarifying question, there is no visible context — the user has to scroll up to understand what was produced.
- The plan skill can silently add packages/dependencies without calling them out, which surprises the user.

**Who is the primary user/beneficiary?**
Any user of this config (shared or open-sourced `claude-setup`).

**What does success look like?**
Both behaviours present:
- A concise summary is always printed to the terminal **before** any `AskUserQuestion` call in `/research` and `/plan`.
- The `/plan` prompt explicitly instructs Claude to flag new dependencies with a dedicated warning section or callout.

**Constraints?**
No preference — whatever produces the best outcome (minimal diff or section rewrite are both acceptable).

## Refined Goal

Two targeted prompt changes across the skill files:

1. **`plan` skill** — Add an instruction requiring Claude to output a "Dependencies" section (or explicit callout) whenever the plan introduces new packages, libraries, or external tools. This must be clearly marked (e.g. `> ⚠️ New dependencies:`) so the user cannot miss it.

2. **`research` and `plan` skills** — Before any `AskUserQuestion` call, Claude must first print a summary of what it found/produced (key findings, plan outline, etc.) as plain terminal output. The question comes *after* the summary, never before.

## Next Steps
Use `/research 0002` to begin codebase study (locate the relevant skill `.md` files and understand current prompt structure).
