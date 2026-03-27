Create an implementation plan for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad project number from `$ARGUMENTS` to 4 digits
2. Find project folder: `.claude-plan/NNNN - */`
3. If not found, error: "Project NNNN not found. Use /new-idea to create a project."
4. Read in order: `idea.md`, `research.md` (if they exist)
5. Ask 3-5 questions on the implementation if there is any uncertainty/ambiguity on how the feature should be planned. Write every answer into plan.md under a **Pre-Plan Decisions** section — do not leave answers only in chat.
6. Write `.claude-plan/NNNN - Description/plan.md` using full markdown syntax (headings, bullet lists, bold, inline code, code blocks where appropriate). Structure:
   - **Pre-Plan Decisions**: questions asked in step 5 and the user's answers
   - **Approach**: what you'll do and why, referencing research findings and pre-plan decisions
   - If the plan introduces any new packages, libraries, or external tools: a `> ⚠️ New dependencies: <list>` callout block placed immediately after the Approach section
   - **Changes**: for each file to be modified or created, show actual code changes (not pseudocode) with file paths
   - **Trade-offs**: alternatives considered and why this approach was chosen
   - **Steps**: a numbered checklist of discrete implementation tasks in this format:
     ```
     - [ ] Task 1
     - [ ] Task 2
     - [ ] Task 3
     ```
7. Output a concise summary of the plan as plain text — approach, key changes, and checklist outline. Complete this output fully before proceeding to the next step.
8. Only after the summary above has been output, ask me 3-5 questions on design choices or tough decisions you had to make while writing the plan. Write every answer into plan.md under a **Design Decisions** section — do not leave answers only in chat. Update plan.md with any changes that result from the discussion.

Plan to write tests if this fits the repository's current test standard/coverage.

Do not implement anything. Write the plan only, then wait for explicit confirmation.

**Do NOT proceed to `/implement NNNN` under any circumstances until the user explicitly says to. Never self-trigger the next step.**

> **Note:** Context will be cleared when you move to the next step. All decisions are saved in `plan.md`. Run `/implement NNNN` only when explicitly told to proceed.
