Review project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad the project number from `$ARGUMENTS` to 4 digits (NNNN).
2. Find project folder: `.claude-plan/NNNN - */`. If not found, error: "Project NNNN not found."
3. Read `.claude-plan/NNNN - */idea.md` — understand the original intent and refined goal.
4. Run `git log --oneline -5` to see recent commits.
5. Run `git diff HEAD~1` to get the default diff (latest commit).
   - If the most recent commit message does not reference project NNNN, or the diff is unexpectedly small relative to what `idea.md` describes, or the commit message looks like a partial/WIP commit, pause and ask: "This diff covers only one commit — does it represent the full feature, or should I widen the range (e.g., `git diff main...HEAD`)?"
   - Use whatever range the user confirms, or proceed with `HEAD~1` if it looks complete.
6. For any changed file where the diff alone lacks context, read the full file.
7. Perform a structured review using all five dimensions below. For each finding, assign severity (Medium or High) and cite `file:line` where possible. Skip Low severity (style, naming preferences, trivial suggestions).

**Review dimensions:**

- **Intent alignment**: Does the implementation match `idea.md`'s refined goal? Flag anything missing, out of scope, or misinterpreted.
- **Correctness**: Logic errors, off-by-ones, unhandled edge cases, incorrect assumptions — visible from the diff.
- **Codebase pattern adherence**: Compare with surrounding files. Flag deviations in naming, structure, error handling style, or conventions established elsewhere in the repo.
- **Modularity / SRP**: Functions or files doing too much. Obvious cases where splitting or abstracting would prevent future pain. Also flag premature abstractions.
- **CLAUDE.md compliance**: Does the change follow instructions in `.claude/CLAUDE.md`? Check for violations of stated workflow, patterns, or constraints.

**Severity definitions:**
- **High**: Correctness bugs, security issues (injection, unvalidated input at system boundaries, auth bypass), major scope misses, changes that actively make the codebase worse.
- **Medium**: Edge cases that will likely be hit in practice, pattern deviations that will confuse future contributors, missed abstractions that will cause pain when the code is next touched.

8. Determine the output filename:
   - If `.claude-plan/NNNN - */review.md` does not exist → use `review.md`
   - If it exists → try `review-2.md`, `review-3.md`, etc. until a free slot is found
9. Write the findings to that file in this format:

   ```markdown
   # Review: NNNN — <project name>
   ## Diff base: <what was diffed>
   ## Date: <today>

   ### High severity

   - **[file:line]** <finding>
     **Fix:** <atomic change — e.g. "In `foo.md:12`, replace X with Y"> OR **Needs own feature:** <one sentence on why>

   *(If no findings at this level, write "None.")*

   ### Medium severity

   - **[file:line]** <finding>
     **Fix:** <atomic change> OR **Needs own feature:** <one sentence on why>

   *(If no findings at this level, write "None.")*

   ### Summary
   <1–3 sentence overall assessment>
   ```

   For each finding, append either:
   - **Fix:** — a self-contained change small enough to implement in the current session (exact wording, line edit, or instruction precise enough to execute without further design). If the fix can be stated as a concrete edit, write it that way.
   - **Needs own feature:** — use this when the fix requires design decisions, touches multiple systems, or is large enough to warrant its own `/new-idea` project. Write one sentence explaining why.

   If a severity section has no findings, write "None." and omit the Fix/Needs own feature lines.

10. Print the same findings to chat.
