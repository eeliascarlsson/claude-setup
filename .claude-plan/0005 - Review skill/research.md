# Research: 0005 - Review Skill

## What exists

### Skill file format (`.claude/commands/*.md`)
- Plain markdown files, no YAML frontmatter
- Use `$ARGUMENTS` for user-supplied params (e.g. project number)
- Very short: typically 4–30 lines, terse numbered steps
- Examples: `commit.md` (47 lines), `implement.md` (26 lines), `quick-job.md` (4 lines)
- Skills operate on `.claude-plan/NNNN - */` project folders

### Project folder convention
- `.claude-plan/NNNN - Description/idea.md` — original intent and refined goal
- `.claude-plan/NNNN - Description/plan.md` — implementation plan
- No `review.md` or analogous artifact exists yet

### Internal review skill (reference, not in repo)
- Uses `gh` CLI for PR-based workflows (not applicable here — local review)
- Runs 5 parallel agent dimensions: CLAUDE.md compliance, bug scan, git history, prior PR comments, code comment adherence
- Scores each issue 0–100, filters below 80
- Key insight: most value comes from **what to look for**, not orchestration

### CLAUDE.md
- Located at `.claude/CLAUDE.md` — minimal, just describes workflow commands
- No project-specific conventions yet (section marked empty)

## How it connects
- `/review NNNN` → read `.claude-plan/NNNN - */idea.md` → run `git diff` → review changed files → output findings
- No new files need to be written (no `review.md` artifact required by the idea)
- No external tools needed beyond `git diff` / reading files

## Constraints
- Must match existing skill brevity — **not** a long orchestration script
- Focus on **what to look for**, not how to parallelize or orchestrate agents
- Should work for any repo (generic, not GitHub-specific)
- Output should cite file:line references
- Filter to medium/high severity only — skip nitpicks

## What the review should check (key dimensions)
1. **Intent alignment** — does the implementation match `idea.md`'s refined goal?
2. **CLAUDE.md compliance** — does code follow project-specific instructions?
3. **Obvious bugs** — correctness issues visible in the diff itself
4. **Codebase pattern adherence** — naming, structure, conventions from surrounding code
5. **Modularity** — functions/files doing too much; obvious abstraction opportunities

## Risks
- Skill too long → defeats the pattern; must stay concise
- Too much orchestration language → user explicitly said to avoid this
- Asking Claude to review without concrete heuristics → vague output; need to embed specific review criteria

## Key files
- **Create**: `.claude/commands/review.md`
- **Read during execution**: `.claude-plan/NNNN - */idea.md`, `.claude/CLAUDE.md`, changed files via git
