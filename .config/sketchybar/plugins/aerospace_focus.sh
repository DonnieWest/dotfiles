#!/usr/bin/env sh

BG=0xff03090e
FG=0xffe6f9f7
GREEN=0xff50fa7b
BLUE=0xff0c2132

focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

[ -n "$focused" ] || exit 0

set --

for workspace in 01 02 03 04 05 06 07 08 09 10; do
  if [ "$workspace" = "$focused" ]; then
    set -- "$@" \
      --set "aerospace.$workspace" \
        drawing=on \
        background.color=$BLUE \
        icon.color=$GREEN \
        label.color=$GREEN
  else
    set -- "$@" \
      --set "aerospace.$workspace" \
        background.color=$BG \
        icon.color=$FG \
        label.color=$FG
  fi
done

sketchybar "$@"

"$HOME/.config/sketchybar/plugins/aerospace_workspaces.sh" &
