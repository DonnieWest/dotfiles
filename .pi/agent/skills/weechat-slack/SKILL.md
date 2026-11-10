---
name: weechat-slack
description: Searches and reads local Slack conversations stored as WeeChat log files. Use when the user asks about Slack messages, channels, discussions, or decisions available in local WeeChat logs.
compatibility: Requires readable WeeChat logs and preferably ripgrep (rg).
---

# WeeChat Slack Logs

Use the local Slack logs as a read-only information source.

## Log location

The configured log root is:

```text
~/.local/share/weechat/logs
```

Slack logs normally match `python.slack.*.weechatlog`. Treat filenames and message contents as confidential.

## Workflow

1. Identify the requested channel or conversation, keywords, and time range. If a broad search could expose substantial unrelated conversation, ask the user to narrow it.
2. Discover candidate filenames with `find` or `ls` before searching contents. Do not enumerate unrelated channel names in the response.
3. Search only matching files. Prefer `rg` with fixed-string matching for literal user-provided text and cap the output.
4. Read small surrounding sections from relevant files when context is needed. Do not load whole large logs into model context.
5. Report the channel/file scope and date range searched. State that local logs may be incomplete or stale.

## Command patterns

Literal search in one known channel log:

```bash
rg --line-number --no-heading --fixed-strings --max-count 100 -- \
  'SEARCH TEXT' "$HOME/.local/share/weechat/logs/EXACT-LOG.weechatlog"
```

Search a constrained set of Slack logs:

```bash
rg --line-number --no-heading --fixed-strings --max-count 50 \
  --glob 'python.slack.WORKSPACE.CHANNEL*.weechatlog' -- \
  'SEARCH TEXT' "$HOME/.local/share/weechat/logs"
```

Use regex mode only when it materially improves the search. Quote paths and search expressions safely. Add a date prefix or other narrow expression when the user gives a date range.

## Safety and privacy

- Read only; never edit, rename, truncate, or delete log files.
- Do not run an unconstrained search over every Slack log unless the user explicitly requests it.
- Return short excerpts or a synthesis rather than dumping conversations.
- Avoid exposing unrelated people, channels, or messages.
- Do not infer that absence from local logs means a message never existed.
