---
description: Determine and run the appropriate verification for current changes
argument-hint: "[scope]"
---
Inspect the repository and current changes, determine the project's intended verification commands, and run the narrowest relevant tests, type checks, lint, and formatting checks. Fix failures caused by the current changes when safe. Distinguish new failures from pre-existing or environmental failures and report exact commands and outcomes.

Scope: ${ARGUMENTS:-current changes}
