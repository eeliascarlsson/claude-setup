Implement the plan for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad project number from `$ARGUMENTS` to 4 digits
2. Find project folder: `.claude-plan/NNNN - */`
3. If not found, error: "Project NNNN not found."
4. Read `.claude-plan/NNNN - Description/plan.md`
5. Follow the plan exactly. Only implement what is explicitly described in plan.md — nothing more, nothing less:
   - Before starting each task, re-read the checklist in plan.md to confirm which task is next
   - Complete the task
   - After completing the task, re-read the checklist in plan.md and mark it: `- [ ]` → `- [x]`
   - Verify the updated checklist looks correct before proceeding to the next task
   - Run type-checking after each logical unit of work
   - Do not add unrequested features, refactor surrounding code, or implement anything not in the plan
6. If you discover anything that requires deviating from the plan — even slightly:
   - Stop immediately
   - Clearly flag the issue and what deviation would be needed
   - Wait for explicit user guidance before continuing

When fully done, summarise what was implemented and flag any follow-up items.

Do not silently adapt. The plan is the contract.
