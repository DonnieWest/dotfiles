---
name: taskwarrior-work
description: Reads work Taskwarrior tasks through the taskwork wrapper. Use for bounded pending, ready, overdue, blocked, project-specific, or recently completed work-task queries; task changes require explicit confirmation.
compatibility: Requires taskwork on PATH, configured with the work-specific Taskwarrior TASKRC.
---

# Taskwarrior Work

Use `taskwork`, not bare `task`, so queries use the work-specific Taskwarrior configuration. Treat task descriptions, annotations, projects, and metadata as private.

## Initial check

Confirm the wrapper without printing configuration contents or task data:

```bash
command -v taskwork
```

The expected wrapper sets the work `TASKRC` and then executes Taskwarrior. Do not inspect credential files or synchronization configuration.

## Read-only queries

Prefer `export` because it produces structured JSON. Keep every query bounded; start with at most 50 tasks and narrow further when possible.

```bash
# Pending
taskwork status:pending limit:50 export

# Ready (Taskwarrior's READY virtual tag)
taskwork status:pending +READY limit:50 export

# Overdue
taskwork status:pending due.before:today limit:50 export

# Blocked
taskwork status:pending +BLOCKED limit:50 export

# One project; replace PROJECT with a trusted literal, passed as one argument
taskwork status:pending 'project:PROJECT' limit:50 export

# Recently completed (last seven days)
taskwork status:completed end.after:today-7days limit:50 export
```

Use narrower dates, projects, UUIDs, or tags when the request permits. Parse JSON locally and return only fields needed to answer the user's request. Do not dump an unbounded task database into the transcript.

Ordinary reports such as `taskwork next limit:20` are read-only, but prefer `export` for reliable parsing.

## Safety

Default to read-only reports and `export`. Before any command that adds, modifies, annotates, starts, stops, completes, deletes, imports, synchronizes, or otherwise changes tasks or Taskwarrior state:

1. Show the intended action and target tasks without exposing unrelated private data.
2. Ask for explicit confirmation immediately before running it.
3. Run only the confirmed operation.

Do not run `taskwork sync`, alter Taskwarrior configuration, inspect credentials, or expose synchronization workflows. Never infer permission to mutate tasks merely because the user asked to inspect or summarize them.
