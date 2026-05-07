#!/usr/bin/env sh

if ! command -v blueutil >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon="" label="blueutil?" label.color=0xffffb86c
  exit 0
fi

powered="$(blueutil -p 2>/dev/null)"

if [ "$powered" = "1" ]; then
  connected="$(blueutil --connected --format json 2>/dev/null | jq 'length' 2>/dev/null)"
  connected="${connected:-0}"
  if [ "$connected" = "0" ]; then
    sketchybar --set "$NAME" icon="" label="on"
  else
    sketchybar --set "$NAME" icon="" label="$connected"
  fi
else
  sketchybar --set "$NAME" icon="" label="off" label.color=0xffff5555
fi
