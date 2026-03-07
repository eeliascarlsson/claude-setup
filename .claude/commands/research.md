Research the following deeply and in great detail: $ARGUMENTS

Study all relevant parts of the codebase — read actual file contents, trace call chains, and understand the intricacies of how everything connects. Do not skim.

Save your complete findings to `.claude-plan/research.md`. Structure it as:
- **What exists**: the relevant code, files, and how they work
- **How it connects**: dependencies, call chains, data flow
- **Constraints**: anything that will affect implementation (existing patterns, types, APIs, conventions)
- **Open questions**: anything ambiguous that needs to be resolved before planning

Do research on how tests are currently written and the coverage and make a judgement if and how the new feature should be tested.

Do not suggest solutions or propose an approach. Research only. When done, tell me `.claude-plan/research.md` is ready for review.
