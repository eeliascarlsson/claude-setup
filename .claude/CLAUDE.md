# Claude Code Instructions

## Core Rule

**Never write code until a plan has been explicitly approved.**

The workflow is always: Research → Plan → (annotation cycle) → Implement. Do not skip or merge phases. Do not start implementing while planning, and do not start planning while researching.

**Exception**: When invoked via `/quick-job`, skip all phases and implement directly using your best judgement. Keep changes minimal and focused.

---

## Phase 1: Research

When asked to research a topic or feature:

1. Study the relevant parts of the codebase **deeply and in great detail** — read actual file contents, trace call chains, understand the intricacies of how things connect
2. Do not skim or summarize from filenames alone
3. Save all findings to `.claude-plan/research.md` — do not just report verbally
4. Structure `research.md` with: what you found, how the relevant code works, key constraints, and anything that could affect the implementation

Do not suggest an approach or propose solutions during research. Just document what exists.

---

## Phase 2: Planning

When asked to create a plan (after research is complete):

1. Read `.claude-plan/research.md` thoroughly before writing anything
2. Write a detailed `.claude-plan/plan.md` that includes:
   - The approach and why it was chosen
   - Actual code snippets showing the key changes (not pseudocode)
   - File paths for every file that will be modified or created
   - Trade-offs and alternatives considered
   - A checklist of discrete implementation steps
3. Do not implement anything — write the plan only

After delivering the plan, wait. The user will annotate `.claude-plan/plan.md` with inline notes. When sent back with revisions, update the plan accordingly and wait again. Repeat until the user approves.

---

## Phase 3: Implementation

When told to implement:

1. Follow `.claude-plan/plan.md` exactly — do not deviate without asking
2. As each task or phase is completed, mark it as done in `.claude-plan/plan.md` (e.g. `- [x] task`)
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