#!/usr/bin/env sh

if [ "$SELECTED" = "true" ]; then
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
