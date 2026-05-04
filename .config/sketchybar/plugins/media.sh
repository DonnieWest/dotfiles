#!/usr/bin/env sh

title="$(nowplaying-cli get title 2>/dev/null)"
artist="$(nowplaying-cli get artist 2>/dev/null)"

if [ -n "$title" ] && [ -n "$artist" ]; then
  sketchybar --set "$NAME" label="${artist} - ${title}"
elif [ -n "$title" ]; then
  sketchybar --set "$NAME" label="$title"
else
  sketchybar --set "$NAME" label=""
fi
