Implement the plan for project $ARGUMENTS.

Extract the project number from `$ARGUMENTS` (format: `N` or `NNNN`), zero-pad to 4 digits.

**Steps:**

1. Zero-pad project number from `$ARGUMENTS` to 4 digits
2. Find project folder: `.claude-plan/NNNN - */`
3. If not found, error: "Project NNNN not found."
4. Read `.claude-plan/NNNN - Description/plan.md`
5. Follow the plan exactly:
   - Do not deviate without asking
   - As each task is completed, mark it: `- [ ]` → `- [x]`
   - Run type-checking after each logical unit of work
   - Do not add unrequested features or refactor surrounding code
6. If you discover something requiring plan deviation:
   - Stop immediately
   - Flag the issue to user
   - Wait for guidance

When fully done, summarise what was implemented and flag any follow-up items.

Lastly suggest a commit message for the code you edited.

Do not silently adapt. The plan is the contract.
