#!/usr/bin/env sh

focused="${AEROSPACE_FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
previous="${AEROSPACE_PREV_WORKSPACE:-}"

[ -n "$focused" ] || exit 0

if [ -n "$previous" ]; then
  CACHE_DIR="${TMPDIR:-/tmp}/aerospace-workspaces"
  mkdir -p "$CACHE_DIR"
  printf '%s\n' "$previous" > "$CACHE_DIR/previous"
fi

sketchybar --trigger aerospace_workspace_change \
  FOCUSED_WORKSPACE="$focused"
