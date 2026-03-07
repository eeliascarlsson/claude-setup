Research for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad project number from `$ARGUMENTS` to 4 digits
2. Find project folder: `.claude-plan/NNNN - */`
3. If not found, error: "Project NNNN not found. Use /new-idea to create a project."
4. Read `idea.md` — if it does not exist, error: "idea.md missing for project NNNN. Run /new-idea first." Do not proceed.
5. Study all relevant parts of the codebase thoroughly:
   - Read actual file contents — do not skim or rely on filenames alone
   - Trace every call chain and data flow relevant to the idea
   - Understand how existing patterns, abstractions, and utilities work
   - Identify all integration points, side effects, and shared state
   - Read tests to understand expected behaviour and edge cases
   - Note constraints: performance, compatibility, existing conventions
6. Write `.claude-plan/NNNN - Description/research.md` with:
   - **What exists**: relevant code, files, and how they actually work (be specific — reference line numbers and function names)
   - **How it connects**: data flow, call chains, integration points
   - **Constraints**: technical limitations, existing patterns that must be followed
   - **Risks**: anything that could go wrong or requires special care
   - **Key files**: list of files that will likely need to be modified or created
7. After writing, ask the user via AskUserQuestion:
   - "Did I focus on the right areas? Is there anything I missed or misunderstood?"
   - "Are there other parts of the codebase I should investigate before planning?"
8. If user provides corrections or points to additional areas, re-read the relevant code and update research.md before finishing.

Do not suggest solutions or approaches. Research only — the goal is a complete, accurate picture of the current state.
