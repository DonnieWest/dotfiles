#!/usr/bin/env sh

if scutil --nc list 2>/dev/null | grep -q Connected; then
  sketchybar --set "$NAME" label="VPN" label.color=0xff50fa7b
else
  sketchybar --set "$NAME" label=""
fi
