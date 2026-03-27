Start a new project idea.

**Steps:**

1. Check if `.claude-plan/` exists, create it if not
2. Glob `.claude-plan/` using the pattern `.claude-plan/[0-9][0-9][0-9][0-9] - */` to find all existing project folders. Extract the 4-digit number prefix from each result and find the highest one. If no folders exist, treat the highest as 0.
3. Increment the highest number by 1 and zero-pad to 4 digits (e.g., if highest is 0002, next is `0003`; if none exist, start at `0001`)
4. Ask the user for a short project description (1-5 words) using AskUserQuestion
5. Create folder: `.claude-plan/NNNN - Description/`
6. Before asking, read `.claude-plan/NNNN - Description/questions.md` if it exists. Skip any question from the list below that has already been answered there (or a substantially similar one). If any are skipped, output a brief note: "Skipping already-answered questions." Then ask any remaining questions using AskUserQuestion:
   - What problem does this solve?
   - Who is the primary user/beneficiary?
   - What does success look like?
   - Are there any constraints (time, tech stack, compatibility)?
   - Any similar features/patterns already in the codebase?
7. Write `.claude-plan/NNNN - Description/idea.md` using full markdown syntax (headings, bullet lists, bold, code blocks where appropriate). Structure:
   - **Initial Idea**: (user's original description)
   - **Clarifying Q&A**: (questions and answers)
   - **Refined Goal**: (synthesized understanding)
   - **Next Steps**: "Use /research NNNN to begin codebase study"
   After writing `idea.md`, append all Q&A pairs from step 6 to `.claude-plan/NNNN - Description/questions.md` (create the file if it doesn't exist). Format each entry as:

   **Q:** <question>
   **A:** <answer>

   Separate entries with a blank line.
8. Confirm to user: "Created project NNNN - Description. Use /research NNNN to continue."

> **Note:** Context will be cleared when you move to the next step. All information has been saved to `idea.md`. Run `/research NNNN` when ready.

Do not read any code yet. This phase is purely for understanding intent.
