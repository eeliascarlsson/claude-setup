# Plan: 0002 - Prompt UX Improvements

## Pre-Plan Decisions

**Q: For the summary-before-question fix, how explicit should the ordering constraint be?**
A: Soft sequential — reword so summary and AskUserQuestion are clearly in separate steps, using language like "Only after the summary above has been output, call AskUserQuestion." No explicit ban on same-turn use.

**Q: Where should new dependencies be flagged in /plan?**
A: In plan.md only — a callout block in the plan document. The chat summary is not required to repeat it.

**Q: How should the dependency callout be formatted in plan.md?**
A: `> ⚠️ New dependencies:` blockquote callout, as suggested in idea.md.

---

## Approach

Two files need targeted edits. No new files, no structural rewrites — only the specific steps that have the ordering ambiguity or the missing dependency instruction.

**`research.md` — steps 7/8:**
Step 7 currently says "Write a short summary of the research to the user in the chat." Step 8 says "After writing, ask the user via AskUserQuestion." The "After writing" phrasing implies ordering but doesn't make it unambiguous enough. The fix: reword step 7 to emphasize completing the output first, and reword step 8's opening to "Only after the summary above has been output, call AskUserQuestion."

**`plan.md` — steps 7/8 + step 6 structure:**
Same ordering fix for steps 7/8. Additionally, the step 6 structure list needs a new bullet — after "Approach" — that instructs Claude to include a `> ⚠️ New dependencies:` callout if the plan introduces any new packages, libraries, or external tools.

---

## Changes

### `.claude/commands/research.md`

**Step 7** (line 24) — change:
```
7. Write a short summary of the research to the user in the chat.
```
to:
```
7. Output a concise summary of the research as plain text — key findings, what exists, and what will need to change. Complete this output fully before proceeding to the next step.
```

**Step 8** (line 25) — change:
```
8. After writing, ask the user via AskUserQuestion:
```
to:
```
8. Only after the summary above has been output, ask the user via AskUserQuestion:
```

---

### `.claude/commands/plan.md`

**Step 6 structure** (after the "Approach" bullet, line 14) — insert new bullet:
```
   - If the plan introduces any new packages, libraries, or external tools: a `> ⚠️ New dependencies: <list>` callout block placed immediately after the Approach section
```

**Step 7** (line 23) — change:
```
7. Summarize the plan to me in the chat.
```
to:
```
7. Output a concise summary of the plan as plain text — approach, key changes, and checklist outline. Complete this output fully before proceeding to the next step.
```

**Step 8** (line 24) — change:
```
8. Ask me 3-5 questions on design choices or tough decisions you had to make while writing the plan.
```
to:
```
8. Only after the summary above has been output, ask me 3-5 questions on design choices or tough decisions you had to make while writing the plan.
```

---

## Trade-offs

**Soft sequential vs. explicit ban:** An explicit "do NOT call AskUserQuestion in the same response turn" is stronger but more mechanical. The user chose soft sequential — phrasing the steps as clearly ordered is less brittle and more in keeping with the natural-language instruction style of these files.

**Dependency callout in plan.md only vs. both:** Repeating in chat risks the warning being lost in a long chat summary. In plan.md it's a permanent, reviewable artifact. The user prefers plan.md only.

**Conditional vs. unconditional dependency section:** An unconditional "always include Dependencies section" would add noise to every plan that touches no packages. The conditional `> ⚠️` callout avoids that.

---

## Steps

- [x] Edit `research.md` step 7: reword to emphasize completing the summary output before proceeding
- [x] Edit `research.md` step 8: prefix with "Only after the summary above has been output,"
- [x] Edit `plan.md` step 6: insert dependency callout bullet after the Approach bullet
- [x] Edit `plan.md` step 7: reword to emphasize completing the summary output before proceeding
- [x] Edit `plan.md` step 8: prefix with "Only after the summary above has been output,"

---

## Design Decisions

**Q: Should there be a fallback instruction when no new dependencies are introduced?**
A: No. Silence is the signal — absence of the callout implies no new dependencies. No explicit "No new dependencies" note needed.

**Q: Is "Complete this output fully before proceeding to the next step" the right framing for the summary ordering?**
A: Yes — the phrasing is clear and in keeping with the existing instruction style. No change needed.
