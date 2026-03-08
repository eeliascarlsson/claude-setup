# 0001 - Refactor list-projects skill

## Initial Idea
The current `list-projects` skill is "vibe based" — it just globs folder names and prompts Claude to infer meaning. It should be more mechanical and structured.

## Clarifying Q&A

**What problem does this solve?**
The current skill relies on Claude globbing `.claude-plan/` and guessing project state from folder names alone. It's fragile, inconsistent, and doesn't surface meaningful progress information.

**Who is the primary user/beneficiary?**
The developer using the claude-setup workflow — anyone running `/list-projects` to get an overview of what projects exist and where they are in the pipeline.

**What does success look like?**
- Each project shows its current phase (idea → research → planned → implementing → done)
- Progress is inferred from which files exist (idea.md, research.md, plan.md, etc.)
- Output is consistent and readable every time
- Implementation is either a native tool or a tightly-scoped skill — not a free-form Claude glob-and-guess

**Are there any constraints?**
- Should work for older projects that may only have idea.md
- Prefer a skill if it can be made deterministic enough; consider a native tool if not

**Any similar features/patterns already in the codebase?**
- The existing `list-projects` skill is the direct predecessor
- Other skills (research, plan, implement) follow a file-based pipeline pattern that this should reflect

## Refined Goal
Replace the current vibe-based `list-projects` skill with a deterministic implementation that:
1. Reads the pipeline files that exist per project (`idea.md`, `research.md`, `plan.md`, implementation artifacts)
2. Infers and displays each project's current phase based on file presence
3. Shows a one-line summary per project (extracted from `idea.md` **Refined Goal** field)
4. Outputs a clean, consistent format (table or structured list)

The implementation could be a more prescriptive skill (explicit instructions to read specific files) or a native tool — TBD in research phase.

## Next Steps
Use `/research 0001` to begin codebase study.
