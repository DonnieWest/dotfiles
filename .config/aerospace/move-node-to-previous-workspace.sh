#!/usr/bin/env sh

CACHE_DIR="${TMPDIR:-/tmp}/aerospace-workspaces"
previous=""

if [ -f "$CACHE_DIR/previous" ]; then
  previous="$(cat "$CACHE_DIR/previous")"
fi

if [ -z "$previous" ]; then
  previous="$(aerospace list-workspaces --focused 2>/dev/null)"
fi

[ -n "$previous" ] || exit 0

aerospace move-node-to-workspace "$previous"
"$HOME/.config/aerospace/trigger-sketchybar-workspaces.sh"
