#!/usr/bin/env sh

battery_info="$(pmset -g batt 2>/dev/null)"
percent="$(printf '%s\n' "$battery_info" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
charging="$(printf '%s\n' "$battery_info" | grep -q 'AC Power' && echo true || echo false)"

if [ "$charging" = "true" ]; then
  sketchybar --set "$NAME" icon="" label="${percent:-0}%"
else
  sketchybar --set "$NAME" icon="" label="${percent:-0}%"
fi
