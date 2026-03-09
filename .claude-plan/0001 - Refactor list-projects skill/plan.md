# Plan: 0001 - Refactor list-projects skill

## Approach

Replace the current `list-projects.md` with a shell-injection-based implementation. The skill uses Claude Code's `` !`command` `` syntax to execute a bash script before Claude sees the prompt. The script handles all data collection and formatting deterministically — Claude is a thin display layer only.

**Root cause of current bug:** Claude's Glob tool does not match folder names containing spaces when the pattern itself contains a literal space (e.g., `.claude-plan/NNNN - */`). This caused `/list-projects` to silently return no results even when projects exist. Shell glob patterns (`[0-9][0-9][0-9][0-9]\ -\ */` or quoted) handle spaces correctly — this is the primary reason to move to a script-based approach.

**Why shell injection + script in `commands/`:**
- Fixes the spaces-in-folder-name bug that breaks the Glob tool approach
- Shell injection (`` !`...` ``) is the CC-native pattern for deterministic commands (research.md §Implementation mechanism options)
- The script lives in `.claude/commands/_list-projects.sh` so it's included automatically via the symlink consumers use (research.md §Submodule symlink scope → Option 1)
- A separate script file is easier to maintain and test than inlining bash in a markdown prompt
- No changes to README or install instructions needed

**Phase detection logic** (from research.md §Phase detection):

| Files present | `plan.md` task content | Phase |
|---|---|---|
| Only `idea.md` | — | `idea` |
| `idea.md` + `research.md` (no `plan.md`) | — | `research` |
| `plan.md` present | no checkbox lines | `planned` |
| `plan.md` present | all `- [ ]`, none `- [x]` | `planned` |
| `plan.md` present | mixed `[x]` and `[ ]` | `implementing` |
| `plan.md` present | all `- [x]`, at least one | `done` |

**Summary extraction:** Read `idea.md`, locate `## Refined Goal`, extract the first non-empty non-heading line after it. Truncate to 60 chars with `...` if longer.

## Changes

### `.claude/commands/list-projects.md` (replace)

```markdown
List all projects in `.claude-plan/`.

!`.claude/commands/_list-projects.sh`

Display the table above to the user exactly as printed. Do not add commentary unless the output is empty, in which case say "No projects found. Use /new-idea to create one."
```

### `.claude/commands/_list-projects.sh` (create, chmod +x)

```bash
#!/usr/bin/env bash

PLAN_DIR=".claude-plan"

if [ ! -d "$PLAN_DIR" ]; then
  echo "(no .claude-plan directory found)"
  exit 0
fi

# Collect rows into array so we can check if empty
rows=()

# Shell glob handles spaces in folder names correctly (unlike Claude's Glob tool)
for dir in "$PLAN_DIR"/[0-9][0-9][0-9][0-9]\ -\ */; do
  [ -d "$dir" ] || continue

  folder=$(basename "$dir")
  id="${folder:0:4}"
  name="${folder:7}"  # after "NNNN - "

  idea="$dir/idea.md"
  research_file="$dir/research.md"
  plan_file="$dir/plan.md"

  # Phase detection
  if [ -f "$plan_file" ]; then
    total=$(grep -cE '^\- \[.\]' "$plan_file" 2>/dev/null || true)
    done_count=$(grep -cE '^\- \[x\]' "$plan_file" 2>/dev/null || true)
    todo_count=$(grep -cE '^\- \[ \]' "$plan_file" 2>/dev/null || true)
    total="${total:-0}"; done_count="${done_count:-0}"; todo_count="${todo_count:-0}"

    if [ "$total" -eq 0 ]; then
      phase="planned"
    elif [ "$todo_count" -eq 0 ]; then
      phase="done"
    elif [ "$done_count" -eq 0 ]; then
      phase="planned"
    else
      phase="implementing"
    fi
  elif [ -f "$research_file" ]; then
    phase="research"
  elif [ -f "$idea" ]; then
    phase="idea"
  else
    phase="unknown"
  fi

  # Summary: first non-empty line after "## Refined Goal" in idea.md
  summary=""
  if [ -f "$idea" ]; then
    summary=$(awk '/^## Refined Goal/{found=1; next} found && /^[^#[:space:]]/{print; exit} found && /^[[:space:]]+[^[:space:]]/{print; exit}' "$idea" | head -1)
    if [ ${#summary} -gt 60 ]; then
      summary="${summary:0:60}..."
    fi
  fi

  rows+=("$(printf "%-4s  %-28s  %-13s  %s" "$id" "${name:0:28}" "$phase" "$summary")")
done

if [ ${#rows[@]} -eq 0 ]; then
  echo "(no projects found)"
  exit 0
fi

printf "%-4s  %-28s  %-13s  %s\n" "ID" "Name" "Phase" "Summary"
printf "%-4s  %-28s  %-13s  %s\n" "----" "----------------------------" "-------------" "-------"
for row in "${rows[@]}"; do
  echo "$row"
done
```

## Trade-offs

**Root cause fix — shell glob vs alternatives**: The Glob tool fails on spaces. Shell glob with escaped spaces (`[0-9][0-9][0-9][0-9]\ -\ */`) works correctly. An alternative would be `find "$PLAN_DIR" -maxdepth 1 -type d -name "[0-9][0-9][0-9][0-9] - *"` — equally valid but shell glob is simpler and consistent with the existing naming convention.

**Inline bash vs separate script**: Inline bash (Option C) avoids an extra file, but makes the skill unreadable and untestable. Separate script (Option A) adds one file but is clean, auditable, and runnable standalone.

**Script in `commands/` vs `scripts/`**: `scripts/` would be cleaner organizational hierarchy, but would require updating README install instructions. `commands/_list-projects.sh` is included automatically via the existing symlink — zero cost to consumers.

**Claude as display layer vs pure script output**: The skill instructs Claude to display the table verbatim. Keeping Claude involved allows for a graceful empty-state message.

**`grep -c` exit code on no match**: `grep -c` returns exit code 1 if no lines match, which would abort a `set -e` script. The script avoids `set -e` and uses `|| true` to handle zero-match cases safely.

## Steps

- [x] Create `.claude/commands/_list-projects.sh` with the bash script above
- [x] Make it executable: `chmod +x .claude/commands/_list-projects.sh`
- [x] Replace `.claude/commands/list-projects.md` with the shell-injection version
- [x] Manual smoke test: run `.claude/commands/_list-projects.sh` from project root and verify output shows project 0001 in `planned` phase
- [x] Verify spaces in folder name are matched correctly (the bug that triggered this refactor)
