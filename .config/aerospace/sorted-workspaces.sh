#!/usr/bin/env sh

aerospace list-workspaces --all 2>/dev/null | awk '
  /^[0-9]+$/ { printf "0 %010d %s\n", $0, $0; next }
  { printf "1 %s %s\n", tolower($0), $0 }
' | sort -k1,1 -k2,2 | cut -d ' ' -f 3-
