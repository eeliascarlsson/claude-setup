# Plan: 0004 - Commit Skill

## Pre-Plan Decisions

**Q:** What problem does this solve?
**A:** Too many steps to commit during workflow — reduces friction when committing mid-task or at the end of a plan phase.

**Q:** What does success look like?
**A:** Run `/commit 0004` → staged diff analyzed → good message written and committed. Full end-to-end in one command.

**Q:** Are there any constraints?
**A:** As part of this project, also remove the git policy about worktrees and committing to dev/main from CLAUDE.md (user no longer wants that restriction).

**Q:** Any similar features/patterns already in the codebase?
**A:** Yes — existing skills like `/implement` and `/plan` show the pattern. Follow the same `.md` skill file format.

---

## Approach

Create a `/commit NNNN` skill that:
1. Takes a project number from `$ARGUMENTS`, zero-pads to 4 digits
2. Checks `git diff --cached` — aborts if nothing is staged
3. Reads `.claude-plan/NNNN - */idea.md` for context (if the folder exists; skips gracefully if not)
4. Analyzes the staged diff to produce a conventional-commit message in the established style
5. Executes the commit via HEREDOC (avoids shell quoting issues with dashes, parens, backticks)

Additionally:
- Remove the `## Git Policy` section from `~/.claude/CLAUDE.md`
- Add `/commit` row to the Commands table in `README.md`

The skill file goes in `.claude/commands/commit.md` (symlinked from `~/.claude/commands/`), matching every other skill in the repo.

---

## Changes

### 1. `.claude/commands/commit.md` — **Create**

```markdown
Commit staged changes for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad project number from `$ARGUMENTS` to 4 digits (NNNN).
2. Run `git diff --cached --stat`. If the output is empty, stop and tell the user: "Nothing is staged. Stage your changes first with `git add`."
3. Run `git diff --cached` to read the full staged diff.
4. Find `.claude-plan/NNNN - */` — if found, read `idea.md` inside it for context. If not found, proceed without it (do not error).
5. Analyze the staged diff (and idea.md if available) to draft a commit message in this exact format:

   ```
   <type>(NNNN): <short imperative summary — comma-separated highlights if multiple>

   - <Concrete change 1>
   - <Concrete change 2>
   - <Concrete change N>

   Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
   ```

   Rules:
   - `<type>` is one of: `feat`, `fix`, `chore`, `refactor`, `docs`, `test` — choose based on the diff
   - The scope in parentheses is the 4-digit project number by default; use a module name instead only if the change clearly belongs to a named module rather than a specific project
   - Subject line ≤ 72 characters
   - Bullets are concrete and specific (what changed, not why)
   - Always include the `Co-Authored-By` trailer

6. Execute the commit using a HEREDOC to avoid shell quoting issues:

   ```bash
   git commit -m "$(cat <<'EOF'
   <subject line>

   <bullet 1>
   <bullet 2>

   Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
   EOF
   )"
   ```

7. After the commit succeeds, output the commit hash and subject line so the user can confirm.
```

### 2. `/home/elias/.claude/CLAUDE.md` — **Edit**

Remove lines 12–16 (the entire `## Git Policy` section):

```diff
-## Git Policy
-
-- **NEVER commit or push directly to `main` or `dev`.**
-- **Only commit to the current worktree branch.** All commits must stay on the branch of the active worktree.
-- Force-push to `main` or `dev` is strictly forbidden.
-
 ## Repository specific stack/patterns
```

### 3. `README.md` — **Edit**

Add a row to the Commands table after `/quick-job`:

```diff
 | `/quick-job` | Implement directly, skipping all phases. For small, well-understood tasks. |
+| `/commit N` | Analyze staged diff for project N, write a conventional commit message, and commit. |
```

---

## Trade-offs

- **Prose instructions vs shell script**: Using prose instructions in the `.md` skill (directing Claude's Bash tool) rather than a new shell script keeps it consistent with all other skills and requires no `settings.json` permission changes.
- **HEREDOC for commit**: The system prompt explicitly warns about quoting issues with dashes/parens/backticks in commit messages. HEREDOC is the established safe pattern.
- **Read `idea.md` for context, not `plan.md`**: `idea.md` is more stable and summarizes intent; `plan.md` may be very long. The staged diff is the ground truth; `idea.md` is supplementary.
- **Graceful handling of missing project folder**: Some commits may not be tied to a `.claude-plan` project (e.g. a quick fix). The skill accepts this and proceeds diff-only.

---

## Steps

- [x] Create `.claude/commands/commit.md` with the skill prose
- [x] Remove `## Git Policy` section from `/home/elias/.claude/CLAUDE.md`
- [x] Add `/commit N` row to the Commands table in `README.md`
