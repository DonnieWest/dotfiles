#!/usr/bin/env sh

airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

if [ -x "$airport" ]; then
  ssid="$($airport -I 2>/dev/null | awk -F': ' '/ SSID/ {print $2; exit}')"
else
  ssid="$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/^Current Wi-Fi Network: //')"
fi

sketchybar --set "$NAME" label="${ssid:-disconnected}"
