Start a new project idea.

**Steps:**

1. Check if `.claude-plan/` exists, create it if not
2. Glob `.claude-plan/` for folders matching `NNNN - *`, find the highest number
3. Increment by 1 and zero-pad to 4 digits (e.g., `0001`, `0002`)
4. Ask the user for a short project description (1-5 words) using AskUserQuestion
5. Create folder: `.claude-plan/NNNN - Description/`
6. Ask 3-5 clarifying questions using AskUserQuestion:
   - What problem does this solve?
   - Who is the primary user/beneficiary?
   - What does success look like?
   - Are there any constraints (time, tech stack, compatibility)?
   - Any similar features/patterns already in the codebase?
7. Write `.claude-plan/NNNN - Description/idea.md` with:
   - **Initial Idea**: (user's original description)
   - **Clarifying Q&A**: (questions and answers)
   - **Refined Goal**: (synthesized understanding)
   - **Next Steps**: "Use /research NNNN to begin codebase study"
8. Confirm to user: "Created project NNNN - Description. Use /research NNNN to continue."

Do not read any code yet. This phase is purely for understanding intent.
