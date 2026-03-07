List all projects in `.claude-plan/`.

**Steps:**

1. Glob search for `.claude-plan/NNNN - */`
2. For each project folder:
   - Extract number and name
   - Check which phase files exist (idea.md, research.md, plan.md)
   - Determine phase: last existing file indicates current phase
3. Display formatted table:
   ```
   Project  Name                    Phase
   -------  ----------------------  ----------
   0001     Auth System             implement
   0002     Dark Mode               research
   0003     API Refactor            idea
   ```

This is a read-only command for project visibility.
