# Research: 0004 - Commit Skill

## What Exists

### Command/Skill Structure

All skills live in `/home/elias/.claude/commands/` as `.md` files. Claude Code loads them and makes each available as `/<filename>` (without `.md`). Current commands:

- `new-idea.md` — creates `.claude-plan/NNNN - Description/idea.md`
- `research.md` — writes `research.md`, asks Q&A
- `plan.md` — writes `plan.md`, asks Q&A
- `implement.md` — follows `plan.md`, checks off tasks, ends with "suggest a commit message"
- `quick-job.md` — direct implementation, no phases
- `list-projects.md` — invokes `_list-projects.sh` via `!` prefix
- `_list-projects.sh` — bash helper, not a skill itself

### Argument Handling Pattern

Every skill uses the same pattern (lines 1–3 of each file):
```
<verb> for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.
```

`$ARGUMENTS` is the Claude Code placeholder for everything after the slash command name.

### Shell Script Invocation

`list-projects.md` shows how to invoke a shell script directly:
```
!`~/.claude/commands/_list-projects.sh`
```
The `!` prefix runs a Bash command. This approach requires the script to be permitted in `settings.json` — currently only `_list-projects.sh` is allowed:
```json
"allow": ["Bash(~/.claude/commands/_list-projects.sh)"]
```
The `/commit` skill will NOT use a shell script — it will use prose instructions directing Claude to run git commands via the Bash tool.

### Commit Message Style

From `idea.md` example and git log inspection:

```
feat(0036): short summary — comma-separated feature list

- Bullet describing change 1
- Bullet describing change 2
- Bullet describing change N

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

Observed from `git log`:
- Subject line uses conventional commit prefix: `feat(...)`, `fix(...)`, `chore(...)`, `improve`, etc.
- The scope in parentheses is either a project number (`0036`) or a module name (`skills`, `list-projects`)
- Body bullets are concrete and specific (what changed, not why)
- `Co-Authored-By` trailer is always present

### `implement.md` ending

`implement.md` currently ends with:
> Lastly suggest a commit message for the code you edited.

This means commits are currently manual — Claude suggests but doesn't execute. The `/commit` skill is the missing piece that actually executes the commit.

### Git State

- Repo is `main` branch, 1 commit ahead of origin
- No staged changes currently
- `.claude-plan/` is untracked (presumably in `.gitignore` given README says it's local-only)

### `~/.claude/CLAUDE.md` Git Policy Section

Lines 13–17 of `/home/elias/.claude/CLAUDE.md` contain:
```markdown
## Git Policy

- **NEVER commit or push directly to `main` or `dev`.**
- **Only commit to the current worktree branch.** All commits must stay on the branch of the active worktree.
- Force-push to `main` or `dev` is strictly forbidden.
```

Per `idea.md`, this entire section must be removed as part of this project.

## How It Connects

- New `commit.md` skill → placed in `/home/elias/.claude/commands/commit.md`
- Since this is the `claude-setup` repo, the file goes in the repo at `.claude/commands/commit.md` (which is symlinked from `~/.claude/commands/`)
- Skill reads `.claude-plan/NNNN - Description/idea.md` for context
- Skill runs `git diff --cached` to inspect staged changes
- Skill generates a commit message following the established pattern
- Skill executes the commit (not just suggests it)
- `~/.claude/CLAUDE.md` = `/home/elias/.claude/CLAUDE.md` — same file, Git Policy section removed

## Constraints

- **No new shell scripts needed**: The skill uses Claude's Bash tool directly
- **No settings.json changes needed**: Claude already has Bash permissions for git commands
- **Pattern must match existing skills**: Same `$ARGUMENTS` extraction, same project folder lookup, same `.claude-plan/NNNN - */` glob pattern
- **Commit format**: Must include `Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>` trailer
- **HEREDOC quoting**: The git instructions in the system prompt warn to use a HEREDOC to pass the commit message to avoid quoting issues

## Risks

- **Empty staged area**: Skill must check `git diff --cached` is non-empty before committing; otherwise it's a no-op or error
- **Quoting in commit message**: Dashes, parentheses, and backticks in the message can break shell interpolation — the skill prompt must instruct use of HEREDOC
- **Project number scope vs module scope**: Some commits use module names (`skills`) rather than project numbers as the scope. The skill should default to the project number but the instruction could mention this is just the default
- **`idea.md` may not reflect staged changes**: The staged diff is the ground truth; `idea.md` is just context. The skill should prioritize reading the diff

## Key Files

| File | Action |
|------|--------|
| `/home/elias/.claude/commands/commit.md` (= `.claude/commands/commit.md` in repo) | **Create** — the new skill |
| `/home/elias/.claude/CLAUDE.md` | **Edit** — remove Git Policy section (lines 13–17) |
| `README.md` | **Edit** — add `/commit` to the Commands table |
