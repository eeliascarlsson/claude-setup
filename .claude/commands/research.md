Research for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad project number from `$ARGUMENTS` to 4 digits
2. Find project folder: `.claude-plan/NNNN - */`
3. If not found, error: "Project NNNN not found. Use /new-idea to create a project."
4. If `idea.md` exists, read it to understand context
5. Study all relevant parts of the codebase:
   - Read actual file contents (not just filenames)
   - Trace call chains and dependencies
   - Understand how existing patterns work
   - Note key constraints and integration points
6. Write `.claude-plan/NNNN - Description/research.md` with:
   - **What exists**: relevant code, files, and how they work
   - **How it connects**: data flow, call chains, integration points
   - **Constraints**: technical limitations, existing patterns to follow
   - **Key files**: list of files that will likely be modified
7. After writing, ask the user via AskUserQuestion:
   - "Did I focus on the right areas?"
   - "Is there anything I misunderstood about the requirements?"
   - "Are there other parts of the codebase I should investigate?"
8. If user provides corrections, update research.md accordingly

Do not suggest solutions or approaches yet. Research only.
