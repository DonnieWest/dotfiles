#!/usr/bin/env sh

focused="$(aerospace list-workspaces --focused 2>/dev/null)"
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$focused" REBUILD_WORKSPACES=1
