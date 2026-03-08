# Research: 0001 - Refactor list-projects skill

## What exists

### Current `list-projects.md` (`.claude/commands/list-projects.md`, lines 1–19)

```
List all projects in `.claude-plan/`.

Steps:
1. Glob search for `.claude-plan/NNNN - */`
2. For each project folder:
   - Extract number and name
   - Check which phase files exist (idea.md, research.md, plan.md)
   - Determine phase: last existing file indicates current phase
3. Display formatted table:
   Project  Name                    Phase
   -------  ----------------------  ----------
   0001     Auth System             implement
   0002     Dark Mode               research
   0003     API Refactor            idea
```

The skill is already somewhat structured, but has two key weaknesses:

1. **Phase ambiguity at the "implement" stage**: It only checks for three files (`idea.md`, `research.md`, `plan.md`). It treats any project with `plan.md` as phase `implement`, but cannot distinguish between "planned but not started", "in progress", and "done". The implement skill (`implement.md`, lines 13–14) modifies `plan.md` in-place by checking off tasks (`- [ ]` → `- [x]`) — it does not create a new file.

2. **No summary extraction**: The current skill shows the folder name only (e.g. "Auth System") — it does not extract the one-line **Refined Goal** from `idea.md` that the idea.md for this project asks for (idea.md line 32: "Shows a one-line summary per project (extracted from `idea.md` **Refined Goal** field)").

### Pipeline file structure

Each project lives in `.claude-plan/NNNN - Description/`. Files created per phase:

| Phase | File created by | Command |
|---|---|---|
| idea | `new-idea.md` | `/new-idea` |
| research | `research.md` | `/research N` |
| planned | `plan.md` | `/plan N` |
| implementing / done | (modifies `plan.md`) | `/implement N` |

The implement skill does **not** create a new artifact — it only mutates `plan.md` task checkboxes. No `done.md` or similar file is written.

### `idea.md` structure (from new-idea.md, lines 17–21)

Fields written:
- `## Initial Idea`
- `## Clarifying Q&A`
- `## Refined Goal`
- `## Next Steps`

The **Refined Goal** section is the canonical one-liner for a project (confirmed in the live `0001` example: idea.md line 29 `## Refined Goal` followed by a multi-sentence block).

### `plan.md` task format (from implement.md, line 13)

Tasks use standard markdown checkboxes:
- `- [ ] Task description` (unchecked)
- `- [x] Task description` (checked)

Detecting implement sub-phases requires reading `plan.md` content and counting checked vs unchecked tasks.

### Settings (`.claude/settings.json`, lines 1–6)

Pre-approved tools for the `.claude-plan/` tree:
```json
{
  "allowedTools": [
    "Edit(.claude-plan/**)",
    "Write(.claude-plan/**)"
  ]
}
```

Read and Glob are not pre-approved but are generally auto-allowed in most permission modes. The list-projects skill is read-only, so this is not a practical blocker.

### No tests

The repository is entirely markdown-based. There are no test files, no scripts, no CI. Nothing to break or maintain test compatibility with.

## How it connects

The pipeline is file-based and linear:
```
/new-idea → idea.md
/research → research.md (requires idea.md)
/plan     → plan.md     (requires idea.md + research.md)
/implement → mutates plan.md in-place (requires plan.md)
```

`/list-projects` is a read-only observer of this pipeline — it reads files but writes nothing. It has no dependencies on other commands.

### Phase detection logic (current vs what's needed)

Current logic: "last existing file indicates current phase" — vague, error-prone.

Needed logic (deterministic):

| Files present | plan.md content | Phase |
|---|---|---|
| Only `idea.md` | — | `idea` |
| `idea.md` + `research.md` | — | `research` |
| `idea.md` + `research.md` + `plan.md` | all `- [ ]` | `planned` |
| `idea.md` + `research.md` + `plan.md` | mixed `[x]` and `[ ]` | `implementing` |
| `idea.md` + `research.md` + `plan.md` | all `- [x]` (or no tasks) | `done` |

Detecting `implementing` vs `done` requires reading `plan.md` content — not just file presence.

### Summary extraction

To show a one-line summary from `idea.md`:
- Read `idea.md`
- Find the `## Refined Goal` heading
- Extract the first sentence or line of text following it

This requires reading file contents — not just checking file existence.

## Implementation mechanism options

The current approach is a markdown skill: Claude is prompted to glob, read files, and reason about phases. The user wants something more mechanical — a script that runs deterministically.

### CC-native: shell injection (`` !`command` ``)

Claude Code supports shell injection in command files. Any `` !`command` `` expression in a `.claude/commands/*.md` file is **executed before Claude sees the prompt** — the output replaces the expression in-place. Claude only receives the rendered result.

Example:
```markdown
List all projects in `.claude-plan/`.

!`./scripts/list-projects.sh`

Display the output above to the user.
```

This is the correct CC-native pattern for deterministic slash commands. The script handles all logic; Claude is just a display layer (or not needed at all if the script formats the output itself).

**Option A — Shell injection + committed script**: A bash script (e.g., `scripts/list-projects.sh`) is committed to the repo. The skill uses `` !`./scripts/list-projects.sh` `` to inject output. Script contains all logic: folder enumeration, file-presence checks, `plan.md` checkbox parsing, `idea.md` Refined Goal extraction, table formatting. Fully deterministic — no Claude reasoning involved in data collection.

**Option B — Shell injection with inline command**: The skill embeds the full bash logic inline via `` !`bash -c '...'` `` or a heredoc-style multiline command. No separate script file, but the skill file becomes harder to read and maintain.

**Option C — MCP tool**: Claude Code supports custom tools via MCP servers (Node.js/Python). Much heavier infrastructure; overkill for this use case.

**Option D — Hooks**: Claude Code hooks run scripts at lifecycle events (SessionStart, etc.). Not suitable — hooks are not on-demand; `/list-projects` needs to run when invoked.

Currently there are **no scripts, no binaries, no build system** in the repo — only `.claude/commands/*.md` files. Option A would be the first script added to the repo.

### Submodule symlink scope

The repo is used as a **git submodule** (README.md lines 65–77), with only the `commands/` directory symlinked into the consuming project's `.claude/`:

```bash
ln -s ../claude-setup/.claude/commands .claude/commands
```

A script at `scripts/list-projects.sh` would **not** be available in consuming projects via this symlink. Three resolution options:

1. Place the script inside `commands/` (e.g., `commands/_list-projects.sh`) — included automatically via the symlink
2. Update README install instructions to also symlink a `scripts/` or `bin/` directory
3. Embed full bash logic inline in the skill (no separate file needed)

## Constraints

1. **Submodule symlink scope**: The installation pattern symlinks only `.claude/commands/` (README.md line 68: `ln -s ../claude-setup/.claude/commands .claude/commands`). A script placed outside `commands/` would not be accessible in consuming projects without additional setup. This is the key structural decision to resolve in planning.

2. **Glob pattern**: The folder naming convention is `NNNN - Description` (4-digit zero-padded number, space-dash-space, description). This is consistent across all commands and must be matched exactly.

3. **Read file count concern**: A thorough list-projects run on a large number of projects would require reading `idea.md` and `plan.md` for each project. For a typical personal workflow (5–20 projects) this is acceptable. A script approach handles this trivially with shell loops.

4. **README documents the workflow** (README.md lines 47–58): The file listing and phase naming should stay consistent with the README's documented structure.

## Risks

1. **Reading plan.md for every project is expensive** if there are many projects. For the target use case (personal dev workflow), this is low risk.

2. **Partial idea.md**: If a user manually creates a project folder without a proper `## Refined Goal` section, summary extraction could fail or return empty. The skill needs a fallback (e.g., show folder name instead).

3. **No `research.md` but has `plan.md`**: Technically possible if someone ran `/plan` without `/research`. The phase detection by file presence handles this — `plan.md` present means at minimum `planned` phase, regardless of `research.md`.

4. **`plan.md` with no checkbox tasks**: A plan written without checkboxes (free-form text only) would have no `- [ ]` or `- [x]` lines. The "all tasks checked = done" rule would incorrectly classify it as `done`. A fallback is needed: if no tasks found, treat as `planned`.

## Key files

Depends on chosen approach:

**Option A (shell injection + script in `commands/`):**
| File | Action |
|---|---|
| `.claude/commands/list-projects.md` | Replace — uses `` !`...` `` to invoke script |
| `.claude/commands/_list-projects.sh` | Create — all listing logic; co-located with commands so symlink covers it |

**Option B (shell injection + script in `scripts/`):**
| File | Action |
|---|---|
| `.claude/commands/list-projects.md` | Replace |
| `scripts/list-projects.sh` | Create — all listing logic |
| `README.md` | Update install instructions to symlink `scripts/` too |

**Option C (fully inline in skill):**
| File | Action |
|---|---|
| `.claude/commands/list-projects.md` | Replace — embeds full bash logic inline via shell injection |
