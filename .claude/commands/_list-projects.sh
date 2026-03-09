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
