# Plan: 0005 - Review Skill

## Pre-Plan Decisions

**Q:** Should the project number be required or optional?
**A:** Required. Always loads `idea.md` for intent alignment.

**Q:** What should the default diff base be?
**A:** `git diff HEAD~1` (latest commit) by default. If Claude suspects the last commit doesn't cover the full feature (e.g., very small diff relative to what `idea.md` describes, or commit message suggests it's partial), ask the user whether to widen the range.

**Q:** Should review output be saved to a file?
**A:** Yes — save to `.claude-plan/NNNN - */review.md`. If `review.md` already exists, increment: `review-2.md`, `review-3.md`, etc.

---

## Approach

Create a single skill file `.claude/commands/review.md`. When invoked as `/review NNNN`:

1. Load `idea.md` to understand original intent and scope
2. Run `git log --oneline -5` to see recent commits, then `git diff HEAD~1` as the default diff
3. Heuristic check: if the diff is unexpectedly small or the commit message looks partial relative to `idea.md`, ask the user whether to widen the diff range (e.g., `git diff main...HEAD`)
4. Read changed files in full if the diff alone lacks sufficient context
5. Apply the 5-dimension review framework (embedded in the skill prompt)
6. Output only medium/high severity findings — skip nitpicks
7. Write findings to the numbered `review.md` file in the project folder, and also print to chat

The review criteria are embedded directly in the skill file so Claude has full guidance without external lookups. The skill stays concise by using imperative bullet steps and a compact but complete review checklist.

---

## Changes

### Create `.claude/commands/review.md`

```markdown
Review project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad the project number from `$ARGUMENTS` to 4 digits (NNNN).
2. Find project folder: `.claude-plan/NNNN - */`. If not found, error: "Project NNNN not found."
3. Read `.claude-plan/NNNN - */idea.md` — understand the original intent and refined goal.
4. Run `git log --oneline -5` to see recent commits.
5. Run `git diff HEAD~1` to get the default diff (latest commit).
   - If the diff is unexpectedly small relative to what `idea.md` describes, or the commit message looks like a partial/WIP commit, pause and ask: "This diff covers only one commit — does it represent the full feature, or should I widen the range (e.g., `git diff main...HEAD`)?"
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

   ### Medium severity

   - **[file:line]** <finding>

   ### Summary
   <1–3 sentence overall assessment>
   ```

10. Print the same findings to chat.
```

---

## Trade-offs

| Option | Rejected reason |
|--------|----------------|
| Make project arg optional | Loses intent alignment — the most valuable review dimension |
| Default to `git diff main...HEAD` | Too broad for a post-commit check; `HEAD~1` is faster and usually right |
| Chat-only output | Loses traceability; saving to `review.md` lets you correlate review → fix → re-review |
| Parallelize review dimensions via agents | Overkill for a skill file; the idea explicitly called for avoiding orchestration complexity |

---

## Steps

- [x] Create `.claude/commands/review.md` with the skill prompt above
- [x] Verify the filename-increment logic is unambiguous in the prompt wording
- [x] Smoke-test by running `/review 0005` after implementation to confirm it finds the project folder, diffs correctly, and writes `review.md`
