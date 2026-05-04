#!/usr/bin/env sh

count="$(gh api notifications 2>/dev/null | jq 'length' 2>/dev/null)"
count="${count:-0}"

if [ "$count" = "0" ]; then
  sketchybar --set "$NAME" label=""
else
  sketchybar --set "$NAME" label="GH $count" label.color=0xffffb86c
fi
