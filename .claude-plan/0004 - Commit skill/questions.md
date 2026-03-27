**Q:** What problem does this solve?
**A:** Too many steps to commit during workflow — reduces friction when committing mid-task or at the end of a plan phase.

**Q:** What does success look like?
**A:** Run `/commit 0004` → staged diff analyzed → good message written and committed. Full end-to-end in one command.

**Q:** Are there any constraints?
**A:** As part of this project, also remove the git policy about worktrees and committing to dev/main from CLAUDE.md (user no longer wants that restriction).

**Q:** Any similar features/patterns already in the codebase?
**A:** Yes — existing skills like `/implement` and `/plan` show the pattern. Follow the same `.md` skill file format.
