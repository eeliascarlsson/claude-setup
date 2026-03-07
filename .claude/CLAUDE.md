# Claude Code Instructions

## Core Rule

**Never write code until a plan has been explicitly approved.**

The workflow is always: (New Project) → Idea → Research → Plan → (annotation cycle) → Implement. Do not skip or merge phases. Do not start implementing while planning, and do not start planning while researching.

**Exception**: When invoked via `/quick-job`, skip all phases and implement directly using your best judgement. Keep changes minimal and focused.

---

## Project Management

- `/new-idea` - Create a new numbered project folder and begin idea phase (auto-increments)
- `/list-projects` - See all projects and their current phase

Each phase command takes a project number argument (e.g., `/research:1`, `/plan:2`, `/implement:1`).

---

## Phase 0: Idea

When asked to explore an idea:

1. Ask 3-5 clarifying questions using the AskUserQuestion tool to understand:
   - What problem this solves
   - Who benefits and how
   - What success looks like
   - Constraints and requirements
2. Save all Q&A to `.claude-plan/NNNN - Description/idea.md`
3. Synthesize a refined goal statement

Do not study code or propose solutions yet. Just clarify intent.

---

## Phase 1: Research

When asked to research a topic or feature:

1. Read `idea.md` if it exists to understand context
2. Study the relevant parts of the codebase **deeply and in great detail**:
   - Read actual file contents
   - Trace call chains
   - Understand integration points
3. Save all findings to `.claude-plan/NNNN - Description/research.md` with structure:
   - What exists
   - How it connects
   - Constraints
   - Key files
4. Ask user if you focused on the right areas or misunderstood anything
5. Update research.md with any corrections

Do not suggest approaches or solutions. Just document what exists.

---

## Phase 2: Planning

When asked to create a plan:

1. Read `idea.md` and `research.md` thoroughly
2. Write a detailed `.claude-plan/NNNN - Description/plan.md` that includes:
   - The approach and why it was chosen
   - Actual code snippets showing key changes (not pseudocode)
   - File paths for every file that will be modified or created
   - Trade-offs and alternatives considered
   - A checklist of discrete implementation steps
3. Do not implement anything — write the plan only

After delivering the plan, wait. The user will annotate the plan file with inline notes. When sent back with revisions, update the plan accordingly and wait again. Repeat until the user approves.

---

## Phase 3: Implementation

When told to implement:

1. Follow `.claude-plan/NNNN - Description/plan.md` exactly
2. As each task or phase is completed, mark it as done: `- [ ]` → `- [x]`
3. Run type-checking after completing each logical unit of work
4. Do not add unrequested features, refactor surrounding code, or introduce new patterns not in the plan
5. If you discover something that requires deviating from the plan, stop and flag it — do not silently adapt

---

## General Behaviour

- Keep changes scoped tightly to what is in the plan
- Preserve existing function signatures unless the plan explicitly changes them
- When the user gives terse corrections during implementation ("wider", "move to X"), apply them in context — the planning phase provides the context needed
- If pasting a reference implementation, match its style and structure closely
- Do not add comments, docstrings, or type annotations to code you did not change
- Do not create files unless the plan specifies them

## Repository specific stack/patterns