# 0004 - Commit skill

## Initial Idea

Add a `/commit XXXX` skill (e.g. `/commit 0039`) that analyzes staged changes, writes a well-structured commit message tied to the project number, and commits — reducing friction in the plan workflow.

**Example of a good commit message:**
```
feat(0036): small fixes — cursor-pointer, injury log compaction, markdown tables, strava-matched = done

- Add global `button { cursor: pointer }` rule to index.css
- Collapse consecutive injury-free days into expandable summary rows in InjuryLogList
- Install remark-gfm@4 and add GFM table renderers to ChatView markdown
- Treat Strava-matched sessions as done (gray bg, muted border, ✓) in SessionCard and SessionListRow
- Include Strava-matched sessions in backend completed_km calculation
- Update SessionListRow test to cover done/future indicator behaviour

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

## Clarifying Q&A

**Q:** What problem does this solve?
**A:** Too many steps to commit during workflow — reduces friction when committing mid-task or at the end of a plan phase.

**Q:** What does success look like?
**A:** Run `/commit 0004` → staged diff analyzed → good message written and committed. Full end-to-end in one command.

**Q:** Are there any constraints?
**A:** As part of this project, also remove the git policy about worktrees and committing to dev/main from CLAUDE.md (user no longer wants that restriction).

**Q:** Any similar features/patterns already in the codebase?
**A:** Yes — existing skills like `/implement` and `/plan` show the pattern. Follow the same `.md` skill file format.

## Refined Goal

Create a `/commit XXXX` skill that:

1. Takes a 4-digit project number as argument (e.g. `0039`)
2. Reads the staged diff (`git diff --cached`)
3. Optionally reads `idea.md` for the project to understand context
4. Generates a commit message matching the established style:
   - `feat(NNNN): short summary line`
   - Blank line
   - Bullet list of concrete changes
   - Blank line
   - `Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>`
5. Commits using that message

Additionally, as part of this project: **remove the Git Policy section from `~/.claude/CLAUDE.md`** that restricts commits to worktree branches and forbids committing to `main`/`dev`.

## Next Steps

Use `/research 0004` to begin codebase study.
