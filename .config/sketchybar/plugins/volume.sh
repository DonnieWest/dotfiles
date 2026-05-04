#!/usr/bin/env sh

volume="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
muted="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

if [ "$muted" = "true" ]; then
  sketchybar --set "$NAME" label="muted" label.color=0xffff5555
else
  sketchybar --set "$NAME" label="${volume:-0}%" label.color=0xffe6f9f7
fi
