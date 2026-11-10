---
description: Run a parallel P0-P3 review with a ship verdict
argument-hint: "[target]"
---
Run an adversarial review of ${ARGUMENTS:-the current uncommitted changes}.

Use `subagent` with one asynchronous `workflowScript` and fresh context to launch three read-only `reviewer` agents in parallel:

1. **Correctness** — regressions, edge cases, error handling, data flow, API compatibility.
2. **Validation** — test coverage, missing assertions, unverified behavior, build/type/lint implications.
3. **Security and simplicity** — security/privacy risks, unnecessary complexity, maintainability, scope drift.

Each reviewer must inspect the actual repository and diff directly, must not modify project/source files, and must return only evidence-backed findings with file and line references. After all reviewers finish, synthesize and deduplicate their reports.

Output one review with:

- A verdict: `SHIP`, `SHIP WITH FOLLOW-UPS`, or `BLOCK`
- Findings ordered by priority:
  - `P0` catastrophic/security-critical
  - `P1` release blocker
  - `P2` important but non-blocking
  - `P3` minor improvement
- A confidence score from 0–100 for each finding
- Exact file and line references
- The smallest safe fix
- A verification summary

Do not edit files unless I explicitly ask for a fix pass after reviewing the findings.
