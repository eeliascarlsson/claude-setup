# 0005 - Review Skill

## Initial Idea

Add a `/review` skill that reads the project idea and the implemented diff/code, then performs a structured code review using state-of-the-art Claude Code review instructions. The review should flag violations of general best practices, codebase-specific best practices, and obvious modularity/refactoring needs.

## Clarifying Q&A

**Q:** What problem does this solve?
**A:** Catching issues late — surfaces best-practice violations and modularity problems right after implementation, before they compound.

**Q:** Who is the primary user/beneficiary?
**A:** Any project using this Claude Code setup (generic across projects).

**Q:** What does success look like?
**A:** Actionable inline feedback focused on medium/high severity issues. Ignore trivial nitpicks. Especially important to catch code that is actively making the codebase worse and should be rewritten/refactored.

**Q:** Any constraints on approach?
**A:** None — use best judgment.

## Refined Goal

Create a `/review NNNN` skill that:

1. **Reads context**: Loads `idea.md` from the relevant project folder to understand the original intent and scope.
2. **Reads the diff**: Uses `git diff` (or reads changed files) to see what was actually implemented.
3. **Performs a structured review** using SOTA Claude Code review criteria:
   - **General best practices**: Does the code follow language/framework idioms? Are there security, performance, or correctness issues?
   - **Codebase best practices**: Does the implementation fit the patterns already established in this repo (naming, structure, conventions)?
   - **Modularity**: Are there obvious cases where code should be split, abstracted, or refactored? Flag when a function/file is doing too much.
   - **Intent alignment**: Does the implementation actually solve what `idea.md` described?
4. **Severity filter**: Only surface medium/high severity issues. Skip style nitpicks and trivial suggestions. Prioritize issues that make the codebase worse or that will create tech debt.
5. **Output format**: Inline feedback with file:line references where possible, grouped by severity or concern type.

## Skill Design Notes

- Trigger: `/review NNNN` where NNNN is the project ID
- The skill prompt should instruct Claude to:
  - Read `.claude-plan/NNNN - */idea.md` first (understand intent)
  - Run `git diff main...HEAD` or similar to get the implementation diff
  - Read any new/changed files in full if needed for context
  - Apply the review framework above
  - Output only actionable, medium/high severity findings
- The review prompt itself should embed SOTA review heuristics directly (not link out), so Claude has full guidance without needing external lookups.

## Next Steps

Use `/research 0005` to begin codebase study (look at existing skill files for pattern/structure).
