---
description: Review current changes for correctness, security, and regressions
argument-hint: "[focus]"
---
Review the current working-tree changes. Inspect the relevant surrounding code and repository guidance. Focus on correctness, regressions, security, error handling, concurrency, and missing tests. Run appropriate read-only checks when useful.

Report findings first, ordered by severity, with file and line references. Avoid style-only comments unless they affect maintainability. If no material findings exist, say so and note residual risks or untested areas.

Additional focus: ${ARGUMENTS:-none}
