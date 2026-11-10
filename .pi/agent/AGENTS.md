# Global working preferences

## Operating style
- Be proactive: when the request is clear, inspect the repository and complete the work rather than only describing it.
- Ask a focused question only when ambiguity would materially change the implementation, risk, or scope. Offer concrete options.
- Prefer the smallest coherent change that solves the problem. Avoid unrelated refactors and speculative abstractions.
- Follow repository-local `AGENTS.md`, conventions, scripts, and package-manager choices; local instructions override these global preferences.
- Use dedicated `read`, `grep`, `find`, and `ls` tools for inspection. Use `bash` for commands and workflows those tools do not cover.
- Read relevant code and configuration before editing. Do not guess APIs that can be checked locally or in current documentation.

## Implementation
- Preserve existing behavior unless the user requested a behavior change.
- Handle meaningful failure modes and edge cases, but do not add defensive complexity without a concrete reason.
- Keep types strict. Avoid suppressing diagnostics or using broad `any` types as a shortcut.
- Do not modify generated files, lockfiles, vendored code, or dependencies unless required by the task.
- Never expose, print, commit, or replace secrets. Treat `.env*`, credentials, private keys, tokens, and auth stores as sensitive.

## Operational reliability
- Before running commands, establish the repository or package root and inspect its manifest for the actual package manager and available scripts. Use paths relative to that root; do not guess paths or script names.
- If a project report says its graph is still building, retry once after the build. If it remains unavailable, continue with direct file inspection and state the limitation.
- Before browser testing, inspect available tabs or pages and confirm the configured browser endpoint is reachable. For UI changes, verify the relevant interactions and responsive layouts in the live page; do not claim visual success from code inspection alone.
- Preserve pre-existing and unrelated working-tree changes. Avoid broad formatting; run only the relevant formatter and inspect the diff for formatting churn before finishing.
- After a tool failure, use its output to change the next attempt. Do not repeat the same command or browser action unchanged; report blockers that require user input or an unavailable service.

## Verification
- After changes, run the narrowest relevant formatter, type check, lint, and tests available in the project.
- Expand verification when changes are broad or risky. Do not claim checks passed unless they were actually run.
- Review the final diff for accidental edits, debug output, secret material, and incomplete work.
- Summarize changed files, behavior, and verification results concisely. Call out anything not verified.

## Git and destructive actions
- Do not commit, push, force-push, rewrite history, publish packages, or create releases unless explicitly requested.
- Do not discard unrelated working-tree changes.
- Ask before destructive or difficult-to-reverse operations.

## Planning
- For complex or high-risk work, use plan mode or maintain a short task list and update it as work progresses.
- Keep simple work simple; do not create ceremony for one-step tasks.
