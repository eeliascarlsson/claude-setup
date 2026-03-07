Create an implementation plan for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad project number from `$ARGUMENTS` to 4 digits
2. Find project folder: `.claude-plan/NNNN - */`
3. If not found, error: "Project NNNN not found. Use /new-idea to create a project."
4. Read in order: `idea.md`, `research.md` (if they exist)
5. Ask 3-5 questions on the implementation if there is any uncertanties/ambgiuty on how the feature should be planned.
6. Write `.claude-plan/NNNN - Description/plan.md` with:
   - **Approach**: what you'll do and why, referencing research findings and pre-plan decisions
   - **Changes**: for each file to be modified or created, show actual code changes (not pseudocode) with file paths
   - **Trade-offs**: alternatives considered and why this approach was chosen
   - **Steps**: a numbered checklist of discrete implementation tasks in this format:
     ```
     - [ ] Task 1
     - [ ] Task 2
     - [ ] Task 3
     ```
7. Summarize the plan to me in the chat.
8. Ask me 3-5 questions on design choices or though decisions you had to take will making the plan.


Plan to write tests if this fits the repository's current test standard/coverage.

Do not implement anything. Write the plan only, then wait.

Do not implement anything until I explicitly say to proceed with implementation.
