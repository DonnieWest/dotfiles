#!/usr/bin/env sh

state="$(aerospace list-workspaces --all --format '%{workspace} %{workspace-is-focused}' 2>/dev/null)"
[ -n "$state" ] || exit 0

focused="$(printf '%s\n' "$state" | awk '$2 == "true" { print $1; exit }')"
[ -n "$focused" ] || focused="$(aerospace list-workspaces --focused 2>/dev/null)"

set --

for workspace in 01 02 03 04 05 06 07 08 09 10; do
  drawing=off

  if printf '%s\n' "$state" | awk -v workspace="$workspace" '$1 == workspace { found=1 } END { exit !found }'; then
    drawing=on
  fi

  if [ "$workspace" = "$focused" ]; then
    drawing=on
  fi

  set -- "$@" \
    --set "aerospace.$workspace" \
      drawing=$drawing
done

[ "$(aerospace list-workspaces --focused 2>/dev/null)" = "$focused" ] || exit 0
sketchybar "$@"
