**Q:** What problem does this solve?
**A:** Catching issues late — surfaces best-practice violations and modularity problems right after implementation, before they compound.

**Q:** Who is the primary user/beneficiary?
**A:** Any project using this Claude Code setup (generic across projects).

**Q:** What does success look like?
**A:** Actionable inline feedback focused on medium/high severity issues. Ignore trivial nitpicks. Especially important to catch code that is actively making the codebase worse and should be rewritten/refactored.

**Q:** Any constraints on approach?
**A:** None — use best judgment.

**Q:** Should the project number (NNNN) be required or optional?
**A:** Required. Always loads idea.md for intent alignment.

**Q:** What should the default diff base be?
**A:** git diff HEAD~1 (latest commit) by default. If the diff looks unexpectedly small or partial relative to idea.md, ask the user whether to widen the range.

**Q:** Should review output be saved to a file?
**A:** Yes — save to .claude-plan/NNNN - */review.md. If review.md already exists, increment: review-2.md, review-3.md, etc.
