#!/usr/bin/env sh

settings="$(osascript -e 'set volumeSettings to get volume settings' -e 'return (output volume of volumeSettings as text) & " " & (output muted of volumeSettings as text)' 2>/dev/null)"
volume="${settings%% *}"
muted="${settings#* }"

if [ "$muted" = "true" ]; then
  sketchybar --set "$NAME" label="muted" label.color=0xffff5555
else
  sketchybar --set "$NAME" label="${volume:-0}%" label.color=0xffe6f9f7
fi
