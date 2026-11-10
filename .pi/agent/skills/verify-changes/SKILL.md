---
name: verify-changes
description: Verifies code changes using repository-native formatting, type checking, linting, tests, and diff review. Use after implementing or fixing code, before declaring work complete.
---

# Verify Changes

1. Read repository instructions and inspect changed files with `git status --short` and the relevant diff.
2. Discover intended commands from package scripts, task runners, CI configuration, and contributor docs. Do not invent commands when the repository declares them.
3. Run the narrowest relevant checks first: formatter/check, type checker or compiler, linter, focused tests.
4. Expand to broader tests when the change is cross-cutting or the focused checks are insufficient.
5. If a check fails, determine whether the failure is caused by the current work, pre-existing, or environmental. Fix only failures in scope unless asked otherwise.
6. Review the final diff for accidental files, generated artifacts, debug output, weak type escapes, incomplete TODOs, and secret material.
7. Report exact commands and outcomes. Never imply an unrun check passed.
