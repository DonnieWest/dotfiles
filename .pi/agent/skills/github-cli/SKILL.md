---
name: github-cli
description: Reads GitHub repositories, files, issues, pull requests, workflows, and other metadata through the authenticated gh CLI. Use for GitHub information that is not already available in the local checkout.
compatibility: Requires GitHub CLI (gh) on PATH and authenticated for the requested repository. Offline pull-request review also requires prr on PATH.
---

# GitHub CLI

Use `gh` as a read-only GitHub information source. For code already present in the current checkout, prefer Pi's file tools because they are faster and easier to bound.

## Initial checks

When access is uncertain, check without printing credentials:

```bash
command -v gh
gh auth status
```

Resolve the current checkout's repository when needed:

```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

Use `--repo OWNER/REPO` or an explicit API path when the current directory may refer to the wrong repository.

## Read patterns

Repository metadata:

```bash
gh repo view OWNER/REPO --json nameWithOwner,description,defaultBranchRef,url
```

Remote file content without cloning:

```bash
gh api -H 'Accept: application/vnd.github.raw+json' \
  'repos/OWNER/REPO/contents/PATH?ref=REF'
```

Issue or pull request details:

```bash
gh issue view NUMBER --repo OWNER/REPO \
  --json number,title,state,author,assignees,labels,body,comments,url

gh pr view NUMBER --repo OWNER/REPO \
  --json number,title,state,author,baseRefName,headRefName,body,files,reviews,comments,url
```

Bounded searches:

```bash
gh search issues 'QUERY' --repo OWNER/REPO --limit 50 \
  --json number,title,state,url,updatedAt

gh search code 'QUERY' --repo OWNER/REPO --limit 50 \
  --json path,repository,textMatches,url
```

Prefer `--json`, `--jq`, explicit fields, and conservative `--limit` values so only relevant data enters model context.

## Offline pull-request review with prr

Use `prr` only when the user asks about offline review. Begin with the read-only status operation:

```bash
prr status
```

When the user asks to begin an offline review, fetch a specific pull request:

```bash
prr get OWNER/REPO/NUMBER
```

`prr get` creates or updates a local review file, so state that local side effect before running it. Afterward, inspect the generated review file with Pi's normal bounded file tools. Avoid `prr edit`, which opens an interactive editor. Edit the review file directly only when the user explicitly asks to draft or change the review.

The following operations require explicit confirmation immediately before execution:

- `prr submit OWNER/REPO/NUMBER` publishes review comments to GitHub.
- `prr apply OWNER/REPO/NUMBER` changes the working tree.
- `prr remove OWNER/REPO/NUMBER` deletes local review state.

Confirm the exact repository and pull-request number. Do not fetch, edit, apply, remove, or submit merely to validate `prr`; use `prr --version` and redirected `prr status` instead.

## Safety

Treat these as mutating operations and do not run them without an explicit user request and confirmation of the target: creating or editing issues, posting comments, closing or reopening items, merging pull requests, changing repository settings, triggering or cancelling workflows, creating releases, deleting resources, or cloning into a persistent location.

Never print tokens or inspect GitHub credential stores. If authorization fails, report the failure and let the user repair authentication.
