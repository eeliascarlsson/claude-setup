# claude-setup

Claude Code workflow configuration for structured multi-project development.

## What This Is

A set of Claude Code commands and instructions that enforce a disciplined workflow: **Idea → Research → Plan → Implement**. Each project lives in its own numbered folder under `.claude-plan/`, keeping concurrent projects separate and stateless.

## Workflow

```
/new-idea
    ↓ creates .claude-plan/0001 - Description/idea.md
/research:1
    ↓ creates .claude-plan/0001 - Description/research.md
/plan:1
    ↓ creates .claude-plan/0001 - Description/plan.md
    ↓ annotation cycle (edit plan.md inline, Claude updates)
/implement:1
    ↓ implements plan, checks off tasks
```

## Commands

| Command | Description |
|---------|-------------|
| `/new-idea` | Start a new project. Auto-increments the project number, asks clarifying questions, writes `idea.md`. |
| `/research:N` | Research the codebase for project N. Reads `idea.md`, studies relevant code, writes `research.md`. |
| `/plan:N` | Create an implementation plan for project N. Reads `idea.md` + `research.md`, writes `plan.md`. |
| `/implement:N` | Implement the plan for project N. Follows `plan.md` exactly, checks off tasks as completed. |
| `/list-projects` | Show all projects and their current phase. |
| `/quick-job` | Implement directly, skipping all phases. For small, well-understood tasks. |
| `/commit N` | Analyze staged diff for project N, write a conventional commit message, and commit. |

**Usage examples:**

```
/new-idea
/research:1
/plan:1
/implement:1
/research:2
/plan:2
/list-projects
```

## Project Files

Each project is stored in `.claude-plan/NNNN - Description/`:

```
.claude-plan/
  0001 - Auth System/
    idea.md        ← clarified intent and goals
    research.md    ← codebase findings
    plan.md        ← implementation plan (annotate this inline)
  0002 - Dark Mode/
    idea.md
    research.md
```

`.claude-plan/` is listed in `.gitignore` — project files are local only and not committed.

## Using in Another Project

Add this repo as a git submodule, then symlink only the `commands` directory into your `.claude/`:

```bash
# In the root of your other project:
git submodule add <url> claude-setup
mkdir -p .claude
ln -s ../claude-setup/.claude/commands .claude/commands
cp claude-setup/.claude/CLAUDE.md .claude/CLAUDE.md
git add .claude .gitmodules claude-setup
git commit -m "chore: add claude-setup"
```

This keeps your own `.claude/CLAUDE.md` (customizable) while sharing the commands via symlink. The `cp` gives you a starting point — edit it freely.

To update the commands later:

```bash
git submodule update --remote claude-setup
git add claude-setup
git commit -m "chore: update claude-setup"
```

> **Note:** The symlink approach does not work on Windows. On Windows, copy the `commands` folder manually instead.

### Troubleshooting

If `ln -s` fails because `.claude/commands` already exists:
```bash
rm -rf .claude/commands
ln -s ../claude-setup/.claude/commands .claude/commands
```

## Key Properties

- **Stateless**: Project number is passed in the command argument, so two Claude instances can work on different projects simultaneously without conflict.
- **Phase-enforced**: Commands check for prerequisite files and warn if they're missing, but don't hard-block.
- **Plan-first**: No code is written until a plan is explicitly approved via the annotation cycle.
