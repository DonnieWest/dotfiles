---
name: jira-cli
description: Reads Jira Cloud work items, projects, and search results through the authenticated Atlassian acli CLI. Use when the user asks to inspect, summarize, or search Jira tickets.
compatibility: Written for Atlassian CLI acli 1.3.36-style jira workitem commands; verify local help if the installed version changes.
---

# Jira CLI

Use `acli` as a read-only Jira information source. The installed command family uses `workitem`, not `issue`.

## Initial checks

When access or account selection is uncertain:

```bash
command -v acli
acli jira auth status
```

Do not switch accounts or start a login flow without user approval. Do not reproduce account details unless they are relevant to resolving an access problem.

## View a work item

Default useful fields:

```bash
acli jira workitem view KEY-123 --json
```

Request only fields needed for the task:

```bash
acli jira workitem view KEY-123 \
  --fields 'key,issuetype,summary,status,assignee,reporter,priority,description,comment' \
  --json
```

Comments can be large. Omit `comment` unless discussion history is needed.

## Search work items

Use bounded JQL searches and structured output:

```bash
acli jira workitem search \
  --jql 'project = TEAM AND statusCategory != Done ORDER BY updated DESC' \
  --fields 'issuetype,key,assignee,priority,status,summary' \
  --limit 50 --json
```

Use `--count` when only the result count is needed. Avoid `--paginate` unless the user explicitly needs the complete result set.

List a bounded number of visible projects only when project discovery is necessary:

```bash
acli jira project list --limit 50 --json
```

## Workflow

1. Extract the ticket key, project, fields, or JQL scope from the request.
2. If the request could target multiple Jira sites or projects, verify the active account and ask for clarification when necessary.
3. Retrieve the smallest useful field set in JSON.
4. Summarize rather than dumping full descriptions or comment histories.
5. Distinguish Jira facts from interpretation and include ticket keys in the answer.

## Safety

Do not run mutating `acli jira workitem` subcommands without an explicit user request and confirmation of the target. This includes `archive`, `assign`, attachment changes, `clone`, comment creation or editing, `create`, `create-bulk`, `delete`, `edit`, link changes, `transition`, `unarchive`, and watcher changes.

Never print API tokens, inspect credential stores, or place credentials in Pi settings, skills, or project files. If authorization fails, report the failure and let the user repair authentication.
