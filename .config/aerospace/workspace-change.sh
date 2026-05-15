#!/usr/bin/env sh

CACHE_DIR="${TMPDIR:-/tmp}/aerospace-workspaces"
mkdir -p "$CACHE_DIR"

focused="${AEROSPACE_FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
previous="${AEROSPACE_PREV_WORKSPACE:-}"

[ -n "$focused" ] && printf '%s\n' "$focused" > "$CACHE_DIR/focused"
[ -n "$previous" ] && printf '%s\n' "$previous" > "$CACHE_DIR/previous"

sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$focused" PREVIOUS_WORKSPACE="$previous"
