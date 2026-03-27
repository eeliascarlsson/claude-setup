# Research: 0003 - Question dedup & log

## What exists

### `.claude/commands/new-idea.md` (26 lines)

Question-phase steps:
- **Step 4** (line 8): `AskUserQuestion` — asks user for a short project description (1–5 words). Fires **before** the project folder is created in step 5. No logging possible at this point.
- **Step 6** (lines 10–15): `AskUserQuestion` — asks 3–5 clarifying questions (problem, user, success, constraints, similar patterns). Fires **after** the folder is created in step 5. These are the loggable questions for `new-idea`.
- **Step 7** (line 16): Writes `idea.md`, which already captures Q&A in a **Clarifying Q&A** section — so answers are preserved in `idea.md`, but not in a shared `questions.md`.
- No reference to `questions.md` anywhere.

### `.claude/commands/research.md` (33 lines)

Question-phase steps (already improved by project 0002):
- **Step 8** (lines 25–28): `AskUserQuestion` — two questions: "Did I focus on the right areas?" and "Are there other parts of the codebase I should investigate?" Fires after the research summary.
- No reference to `questions.md` anywhere.

### `.claude/commands/plan.md` (34 lines)

Question-phase steps (already improved by project 0002):
- **Step 5** (line 11): `AskUserQuestion` — asks 3–5 clarifying/implementation questions **before** writing the plan. This is the step identified as the over-asking problem area.
- **Step 8** (lines 25–26): `AskUserQuestion` — asks 3–5 design-choice questions after the plan summary. Writes answers into `plan.md` under **Design Decisions**.
- No "don't ask unnecessary questions" instruction.
- No reference to `questions.md` anywhere.

### `.claude/commands/implement.md` (28 lines)

- No `AskUserQuestion` calls. Not affected by this project.

### `.claude/commands/quick-job.md` and `.claude/commands/list-projects.md`

- Not part of the structured workflow. Not affected.

### `.claude-plan/NNNN - */` folder convention

Each project has its own folder under `.claude-plan/`. Files currently created per-project: `idea.md`, `research.md`, `plan.md`. The `questions.md` file would be a new addition to this set.

## How it connects

These files are Claude Code slash-command prompts. Each `.md` file is the complete instruction set injected when a user runs the slash command — no shared base prompt, no middleware.

`AskUserQuestion` is a tool call. Claude evaluates the skill instructions step by step, calling the tool when the step requires it. The entire mechanism for checking previously asked questions would need to be embedded as natural-language instructions within each skill file.

The Q&A flow across the workflow:
1. `/new-idea` → step 6 asks 3–5 clarifying questions → step 7 writes answers into `idea.md` (Clarifying Q&A section)
2. `/research` → step 8 asks 2 questions about coverage → no current artifact captures these answers (only in chat)
3. `/plan` → step 5 asks 3–5 pre-plan questions → step 8 asks 3–5 design-choice questions → step 5 answers and step 8 answers both go into `plan.md` (Pre-Plan Decisions and Design Decisions sections)

Note: the step 4 question in `new-idea.md` (short description) fires before the project folder exists and is a one-time naming question — it is not a candidate for logging.

## Constraints

- Changes are to skill prompt files only (`.claude/commands/*.md`) — no code, no build step.
- Instructions must be natural-language that Claude follows reliably.
- Stages that don't find a `questions.md` must gracefully skip the check — the instruction must include an explicit "if the file doesn't exist, skip" clause.
- `new-idea.md` has the constraint "Do not read any code yet" — reading/writing `questions.md` (a plan-folder file, not code) is compatible with this.
- Step 4 in `new-idea.md` fires before the project folder exists, so `questions.md` cannot be written or read at that step.
- The no-unnecessary-questions rule applies to the `plan` stage only (per idea.md).
- The idea says `new-idea` and `research` "can stay as-is" for the over-asking rule, but the shared log still applies to them.
- The Q&A log is also user-editable (plain markdown), so the format must be readable and clean.

## Risks

- **Semantic dedup is fuzzy**: Instructions to "skip semantically equivalent questions" rely on Claude's judgement. If phrased poorly, Claude may over-skip (treating distinct questions as duplicates) or under-skip (treating rephrased duplicates as new). The instruction needs to be scoped to "previously answered" rather than a strict exact-match.
- **Step 4 of new-idea cannot be logged**: The description question fires before the folder exists. No fix is possible here; it should simply not be mentioned as a logged question.
- **Research step 8 has 2 fixed questions**: These are meta-questions about coverage, not project-specific clarifying questions. They are less likely to duplicate across stages, but the mechanism should still check.
- **Plan step 5 is the high-value target**: This is where over-asking is most painful. The no-unnecessary-questions instruction and the dedup check both apply here.
- **Appending format matters**: If the `questions.md` format is not well-defined, later stages may misread it. A consistent heading or separator per Q&A pair is needed.
- **Circular dependency in new-idea**: `questions.md` is written after step 6 (questions answered) but the folder is created in step 5. Reading `questions.md` in step 6 of `new-idea` is safe (folder exists), but it will always be empty or not exist on the first run — the graceful-skip rule handles this.

## Key files

| File | Change needed |
|------|---------------|
| `.claude/commands/new-idea.md` | Before step 6: read `questions.md` if it exists; after step 7: append new Q&A to `questions.md` |
| `.claude/commands/research.md` | Before step 8: read `questions.md` if it exists, skip answered questions; after step 9: append new Q&A to `questions.md` |
| `.claude/commands/plan.md` | Before step 5: read `questions.md` if it exists, skip answered questions + add no-unnecessary-questions rule; after writing answers: append new Q&A; same check before step 8 |
| `.claude-plan/NNNN - */questions.md` | New file, created/appended per project by the skills |
