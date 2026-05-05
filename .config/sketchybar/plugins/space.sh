#!/usr/bin/env sh

workspace="${NAME#aerospace.}"
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$focused" = "$workspace" ]; then
  sketchybar --set "$NAME" \
    background.color=0xff0c2132 \
    icon.color=0xff50fa7b \
    label.color=0xff50fa7b
else
  sketchybar --set "$NAME" \
    background.color=0xff03090e \
    icon.color=0xffe6f9f7 \
    label.color=0xffe6f9f7
fi
