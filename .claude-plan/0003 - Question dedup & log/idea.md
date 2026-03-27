# 0003 - Question dedup & log

## Initial Idea

Reduce redundant and unnecessary questions across the `/new-idea` → `/research` → `/plan` workflow by maintaining a shared `questions.md` log per project. Each stage reads the log before asking questions, skips already-answered ones, and appends new Q&A pairs. Additionally, tune the `plan` stage to avoid over-asking when there is no real ambiguity.

## Clarifying Q&A

**Q: Should the questions.md log be user-editable or just internal to Claude?**
A: Either is fine — no strong preference. Make it work well.

**Q: When a question was already answered, should stages silently skip or briefly acknowledge?**
A: Brief acknowledgment — e.g., a short note like "Skipping already-answered questions."

**Q: Should the stricter no-unnecessary-questions rule apply to all stages or just plan?**
A: Plan stage only. Plan is where over-asking is most painful; idea and research can stay as-is.

## Refined Goal

- Add a `questions.md` file per project folder that acts as a shared Q&A log.
- Each skill (`new-idea`, `research`, `plan`) reads this log at the start of its question phase.
- Before asking a question, check if it (or a semantically equivalent one) has already been answered; if so, skip it with a brief note.
- New Q&A pairs are appended to `questions.md` after each stage.
- For the `plan` stage specifically: add an explicit instruction not to ask questions when there is no genuine ambiguity, and not to repeat any question already in `questions.md`.
- The log file can be read/edited by the user too if desired (it's just markdown).

## Constraints

- Changes are to skill prompt files only (`.claude/skills/` or similar location) — no code changes needed.
- Must not break existing workflow; stages that don't find a `questions.md` should gracefully skip reading it.

## Next Steps

Use `/research 0003` to explore the current skill file locations and prompt structures before planning changes.
