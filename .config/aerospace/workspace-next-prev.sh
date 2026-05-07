#!/usr/bin/env sh

direction="$1"

case "$direction" in
  next|prev) ;;
  *) exit 2 ;;
esac

"$HOME/.config/aerospace/sorted-workspaces.sh" | aerospace workspace --stdin --wrap-around "$direction"
