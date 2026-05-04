#!/usr/bin/env sh

powered="$(system_profiler SPBluetoothDataType 2>/dev/null | awk -F': ' '/Bluetooth Power/ {print $2; exit}')"

if [ "$powered" = "On" ]; then
  sketchybar --set "$NAME" label="BT"
else
  sketchybar --set "$NAME" label=""
fi
