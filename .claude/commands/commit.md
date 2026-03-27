Commit staged changes for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad project number from `$ARGUMENTS` to 4 digits (NNNN).
2. Run `git diff --cached --stat`. If the output is empty, run `git status --short` to check for unstaged changes:
   - If there are modified/untracked files, run `git add -A` to stage everything, then continue.
   - If there is truly nothing to commit (clean working tree), stop and tell the user: "Nothing to commit — working tree is clean."
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
