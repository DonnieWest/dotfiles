#!/usr/bin/env sh

HELPER="$HOME/.config/sketchybar/helpers/corne-battery"

result="$($HELPER 2>/dev/null)"

if [ -n "$result" ]; then
  sketchybar --set "$NAME" icon="" label="$result%" label.color=0xffe6f9f7
else
  sketchybar --set "$NAME" icon="" label="--/--%" label.color=0xffffb86c
fi
