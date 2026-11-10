---
name: local-notes
description: Searches and reads already-synchronized Markdown notes under $HOME/Code/notes using bounded local discovery. Use when asked to find, retrieve, or summarize local notes; notes remain read-only unless editing is explicitly requested.
compatibility: Requires readable $HOME/Code/notes and fd and rg on PATH.
---

# Local Notes

Search only `"$HOME/Code/notes"` (lowercase `notes`). Do not substitute a machine-specific username, broaden discovery to the home directory, or invoke synchronization tools.

## Bounded discovery

Use `fd` to discover at most 100 Markdown files while excluding metadata, trash, synchronization databases, and binary files by default:

```bash
fd --type f --extension md --max-results 100 \
  --exclude .git --exclude .obsidian --exclude .trash \
  --exclude .zk --exclude .vaultexplorer \
  . "$HOME/Code/notes"
```

Narrow by a trusted filename pattern when useful. Treat user text as data, not shell syntax, and quote it as one argument.

## Bounded content search

Use `rg` with explicit exclusions and a result cap:

```bash
rg --line-number --ignore-case --max-count 20 --max-filesize 2M \
  --glob '*.md' \
  --glob '!.git/**' --glob '!.obsidian/**' --glob '!.trash/**' \
  --glob '!.zk/**' --glob '!.vaultexplorer/**' \
  --glob '!*.db' --glob '!*.sqlite' --glob '!*.sqlite3' \
  -- 'SEARCH TEXT' "$HOME/Code/notes" | head -n 100
```

`--max-count` applies per file; `head` bounds what enters the transcript. Also constrain discovery, the search term, or the relevant subdirectory. For more complete searches, redirect matches to a temporary file, count them, and read only a small relevant slice.

Use Pi's file-reading tools to retrieve selected Markdown files or bounded line ranges after discovery. Do not read every note or reveal unrelated filenames or content.

## Safety

Notes are read-only unless the user explicitly requests an edit. Before editing, inspect the exact target file and preserve its existing format. Never delete, move, rename, synchronize, publish, or bulk-rewrite notes without a separate explicit request and confirmation appropriate to the operation.

Do not invoke Nextcloud, `rclone`, or other synchronization commands. Do not inspect keychains, password stores, GPG keys, tokens, CLI credential files, synchronization databases, or excluded metadata directories. Read only the already-synchronized note files.
