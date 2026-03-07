Implement everything in `.claude-plan/plan.md`.

- Follow the plan exactly — do not deviate without flagging it first
- As each step is completed, mark it as done in `.claude-plan/plan.md` with `- [x]`
- Run type-checking after completing each logical unit of work
- If you discover something that requires changing the plan, stop and describe the issue — do not silently adapt
- Do not add unrequested features, refactor surrounding code, or introduce patterns not in the plan
- Preserve existing function signatures unless the plan explicitly changes them
- Run tests after each unit of work

When fully done, summarise what was implemented and flag any follow-up items.

Lastly suggest a commit message for the code you edited.