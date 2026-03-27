# Plan: 0003 - Question dedup & log

## Pre-Plan Decisions

**Q:** What format should `questions.md` use for Q&A entries?
**A:** Simple Q/A blocks — `**Q:** ...` / `**A:** ...` pairs separated by blank lines. No stage headers.

**Q:** Should the research stage's two meta-questions ("Did I focus on the right areas?" / "Are there other parts I should investigate?") be logged in `questions.md`?
**A:** Yes — log them. Consistent behavior: all Q&A pairs across all stages land in `questions.md`.

**Q:** The "only ask if there's genuine ambiguity" rule — which plan stage questions should it apply to?
**A:** Step 8 only (design decisions after writing the plan). Better to ask freely before writing; after the plan is written, only surface genuinely difficult or non-obvious decisions.

---

## Approach

Three skill files (`new-idea.md`, `research.md`, `plan.md`) are edited with two additions each:

1. **Read before asking**: at the start of each question phase, read `.claude-plan/NNNN - Description/questions.md` if it exists. Skip any question substantially similar to one already answered. Output a brief acknowledgment if anything is skipped.
2. **Write after answering**: after each question phase, append new Q&A pairs to `questions.md` (create the file if it doesn't exist).

Additionally, `plan.md` step 8 (post-plan design decisions) gets a gate: if all implementation choices were straightforward, state so and skip the question phase entirely.

`questions.md` is never created by the skills pre-emptively — it is created on first write. If it doesn't exist, the read step silently skips. This means the mechanism is backward-compatible with existing projects that have no `questions.md`.

---

## Changes

### `.claude/commands/new-idea.md`

**Step 6** — add read-before-ask instruction:

```markdown
6. Before asking, read `.claude-plan/NNNN - Description/questions.md` if it exists. Skip any question from the list below that has already been answered there (or a substantially similar one). If any are skipped, output a brief note: "Skipping already-answered questions." Then ask any remaining questions using AskUserQuestion:
   - What problem does this solve?
   - Who is the primary user/beneficiary?
   - What does success look like?
   - Are there any constraints (time, tech stack, compatibility)?
   - Any similar features/patterns already in the codebase?
```

**Step 7** — add write-after-answering instruction (appended to existing step):

```markdown
7. Write `.claude-plan/NNNN - Description/idea.md` using full markdown syntax ... [unchanged]
   After writing `idea.md`, append all Q&A pairs from step 6 to `.claude-plan/NNNN - Description/questions.md` (create the file if it doesn't exist). Format each entry as:

   **Q:** <question>
   **A:** <answer>

   Separate entries with a blank line.
```

---

### `.claude/commands/research.md`

**Step 8** — add read-before-ask and write-after-answering:

```markdown
8. Only after the summary above has been output, read `.claude-plan/NNNN - Description/questions.md` if it exists. Skip any question that has already been answered there (or a substantially similar one). If any are skipped, output a brief note: "Skipping already-answered questions." Then ask any remaining questions via AskUserQuestion:
   - "Did I focus on the right areas? Is there anything I missed or misunderstood?"
   - "Are there other parts of the codebase I should investigate before planning?"
   After receiving answers, append the Q&A pairs to `.claude-plan/NNNN - Description/questions.md` (create if it doesn't exist). Format: `**Q:** <question>` on one line, `**A:** <answer>` on the next, blank line between pairs.
```

---

### `.claude/commands/plan.md`

**Step 5** — add read-before-ask and write-after-answering:

```markdown
5. Read `.claude-plan/NNNN - Description/questions.md` if it exists. Skip any implementation question that has already been answered there (or a substantially similar one). If any are skipped, output a brief note: "Skipping already-answered questions." Ask 3-5 questions on the implementation if there is any uncertainty/ambiguity on how the feature should be planned. Write every answer into plan.md under a **Pre-Plan Decisions** section — do not leave answers only in chat. After writing to plan.md, append the new Q&A pairs to `.claude-plan/NNNN - Description/questions.md` (create if it doesn't exist). Format: `**Q:** <question>` / `**A:** <answer>`, blank line between pairs.
```

**Step 8** — add genuineness gate, read-before-ask, and write-after-answering:

```markdown
8. Only after the summary above has been output, check whether any design decisions while writing the plan were genuinely difficult or non-obvious. If all choices were straightforward with no real alternatives worth discussing, briefly state that and skip the question phase. Otherwise, read `.claude-plan/NNNN - Description/questions.md` if it exists and skip any design question already answered there. Ask 1-5 questions on design choices or tough decisions. Write every answer into plan.md under a **Design Decisions** section — do not leave answers only in chat. Update plan.md with any changes that result from the discussion. After writing to plan.md, append the new Q&A pairs to `questions.md`. Format: `**Q:** <question>` / `**A:** <answer>`, blank line between pairs.
```

---

## Trade-offs

**Natural-language dedup vs. exact-match**: Semantic matching via Claude's judgment is fuzzy but sufficient here — the questions across stages are distinct enough that false-positive skipping is unlikely. Exact-match would be fragile (same question rephrased differently across stages would not match).

**Per-project file vs. global log**: Per-project file (`.claude-plan/NNNN/questions.md`) is the right scope — questions are project-specific and there's no reason to cross-pollinate between projects.

**Inline append vs. separate append step**: Folding the write into the existing step (rather than a new numbered step) keeps the skill files from growing in step count, which makes them easier to read and follow.

**No format validation**: The format (`**Q:** / **A:**`) is simple enough that Claude will reliably produce and parse it. A more structured format (YAML, JSON) would be overkill for plain markdown skill files.

---

## Design Decisions

**Q:** In `new-idea.md`, should the `questions.md` write be folded into step 7 (alongside writing `idea.md`) or be a separate step?
**A:** Fold into step 7. Fewer steps, same effect.

---

## Steps

- [x] Edit `.claude/commands/new-idea.md` — add read-before-ask to step 6
- [x] Edit `.claude/commands/new-idea.md` — add write-after-answering to step 7
- [x] Edit `.claude/commands/research.md` — add read-before-ask and write-after-answering to step 8
- [x] Edit `.claude/commands/plan.md` — add read-before-ask and write-after-answering to step 5
- [x] Edit `.claude/commands/plan.md` — add genuineness gate, read-before-ask, and write-after-answering to step 8
- [ ] Manual smoke-test: run `/new-idea` → `/research` → `/plan` on a throwaway project and verify `questions.md` is created and dedup works
