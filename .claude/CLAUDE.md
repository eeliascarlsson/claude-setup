# Claude Code Instructions

## Workflow

For significant features or changes, use the structured command workflow:
`/new-idea` → `/research N` → `/plan N` → `/implement N`

For small, focused tasks use `/quick-job` or just ask directly.

When in doubt, prefer the structured workflow — it produces better outcomes for non-trivial work.

## Git Policy

- **NEVER commit or push directly to `main` or `dev`.**
- **Only commit to the current worktree branch.** All commits must stay on the branch of the active worktree.
- Force-push to `main` or `dev` is strictly forbidden.

## Repository specific stack/patterns