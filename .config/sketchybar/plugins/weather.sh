#!/usr/bin/env sh

weather="$(curl -fsS 'https://wttr.in/64110?u&format=3' 2>/dev/null | sed 's/^64110: //')"
sketchybar --set "$NAME" label="${weather:-weather unavailable}"
