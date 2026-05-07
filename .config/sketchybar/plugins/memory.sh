#!/usr/bin/env sh

used="$(vm_stat | awk '
  /Pages active/ { active=$3 }
  /Pages wired down/ { wired=$4 }
  /Pages occupied by compressor/ { compressed=$5 }
  END {
    gsub("\\.", "", active)
    gsub("\\.", "", wired)
    gsub("\\.", "", compressed)
    printf "%.1fG", (active + wired + compressed) * 4096 / 1024 / 1024 / 1024
  }
')"
total="$(sysctl -n hw.memsize 2>/dev/null | awk '{ printf "%.1fG", $1 / 1024 / 1024 / 1024 }')"

sketchybar --set "$NAME" label="$used / $total"
