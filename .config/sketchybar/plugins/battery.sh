#!/usr/bin/env sh

percent="$(pmset -g batt | awk -F '[%;]' '/%/ {print $2; exit}' | tr -d ' ')"
charging="$(pmset -g batt | grep -q "AC Power" && echo true || echo false)"

if [ "$charging" = "true" ]; then
  sketchybar --set "$NAME" label="${percent:-0}%+"
else
  sketchybar --set "$NAME" label="${percent:-0}%"
fi
