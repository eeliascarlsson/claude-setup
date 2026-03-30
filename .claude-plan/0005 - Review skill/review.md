# Review: 0005 — Review Skill
## Diff base: untracked files read directly (implementation not yet committed; HEAD~1 showed 0004 changes)
## Date: 2026-03-30

### High severity

None.

### Medium severity

- **[.claude/commands/review.md:11-13]** The heuristic for widening the diff range only triggers on "unexpectedly small diff" or "partial/WIP commit message." It does not explicitly handle the case where the last commit message is for a *different project entirely* (e.g., `feat(0004)` when reviewing project 0005). In that scenario, a Claude instance might not recognise the mismatch as "partial" and could proceed with the wrong diff. A tighter trigger: "if the most recent commit message doesn't reference project NNNN, pause and ask the user to confirm the diff range."

- **[.claude/commands/review.md:34-48]** The output template shows both `### High severity` and `### Medium severity` sections with placeholder bullets. The skill doesn't instruct Claude to omit a section or write "None" when there are no findings at that level. This risks outputting an empty or template-literal section in reviews with findings at only one severity.

### Summary

The implementation is correct and closely follows the plan. Both findings are edge cases in the skill prompt logic: one around diff-range detection when the wrong project was last committed, and one around empty-section output. Neither will cause incorrect reviews in the common case, but the first will silently produce a wrong-project diff if not caught.
