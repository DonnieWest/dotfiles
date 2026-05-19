#!/usr/bin/env sh

BG=0xff03090e
FG=0xffe6f9f7
GREEN=0xff50fa7b
BLUE=0xff0c2132

CACHE_DIR="${TMPDIR:-/tmp}/sketchybar-aerospace"
WORKSPACES_FILE="$CACHE_DIR/workspaces"
CURRENT_FILE="$CACHE_DIR/workspaces.current"
LOCK_DIR="$CACHE_DIR/lock"

mkdir -p "$CACHE_DIR"

item_name() {
  printf 'aerospace.%s' "$(printf '%s' "$1" | tr -c '[:alnum:]_-' '_')"
}

workspace_label() {
  case "$1" in
    01) printf 'Browser' ;;
    02) printf 'Chat' ;;
    03) printf 'Terminal' ;;
    04) printf 'Emulator' ;;
    05|06|07|08|09|10) printf 'Code' ;;
    *) printf '%s' "$1" ;;
  esac
}

workspace_icon() {
  case "$1" in
    0[1-9]) printf '%s' "${1#0}" ;;
    *) printf '%s' "$1" ;;
  esac
}

sort_workspaces() {
  awk '
    /^[0-9]+$/ { printf "0 %010d %s\n", $0, $0; next }
    { printf "1 %s %s\n", tolower($0), $0 }
  ' | sort -k1,1 -k2,2 | cut -d " " -f 3-
}

workspace_is_cached() {
  [ -f "$WORKSPACES_FILE" ] && grep -Fxq -- "$1" "$WORKSPACES_FILE"
}

focused="${FOCUSED_WORKSPACE:-}"
previous="${PREVIOUS_WORKSPACE:-}"

if [ "${REBUILD_WORKSPACES:-0}" != "1" ] && [ -n "$focused" ] && [ -n "$previous" ] && [ "$previous" != "$focused" ] && workspace_is_cached "$focused" && workspace_is_cached "$previous"; then
  sketchybar \
    --set "$(item_name "$previous")" \
      background.color=$BG \
      icon.color=$FG \
      label.color=$FG \
    --set "$(item_name "$focused")" \
      background.color=$BLUE \
      icon.color=$GREEN \
      label.color=$GREEN
  exit 0
fi

attempt=0
while ! mkdir "$LOCK_DIR" 2>/dev/null; do
  attempt=$((attempt + 1))
  [ "$attempt" -ge 20 ] && exit 0
  sleep 0.05
done
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT INT TERM

aerospace list-workspaces --all 2>/dev/null | sort_workspaces > "$CURRENT_FILE.$$"

if [ ! -s "$CURRENT_FILE.$$" ]; then
  focused_fallback="$(aerospace list-workspaces --focused 2>/dev/null)"
  [ -n "$focused_fallback" ] && printf '%s\n' "$focused_fallback" > "$CURRENT_FILE.$$"
fi

mv "$CURRENT_FILE.$$" "$CURRENT_FILE"

focused="${focused:-$(aerospace list-workspaces --focused 2>/dev/null)}"
workspaces_changed=1

if [ -f "$WORKSPACES_FILE" ] && cmp -s "$CURRENT_FILE" "$WORKSPACES_FILE"; then
  first_workspace=""
  IFS= read -r first_workspace < "$CURRENT_FILE"

  if [ -n "$first_workspace" ] && sketchybar --query "$(item_name "$first_workspace")" >/dev/null 2>&1; then
    workspaces_changed=0
  fi
fi

set --

if [ "$workspaces_changed" -eq 1 ]; then
  # Clean up the previous static 1..10 items from the pre-dynamic config.
  for legacy_workspace in 1 2 3 4 5 6 7 8 9 10; do
    set -- "$@" --remove "$legacy_workspace"
  done

  if [ -f "$WORKSPACES_FILE" ]; then
    while IFS= read -r workspace; do
      [ -n "$workspace" ] && set -- "$@" --remove "$(item_name "$workspace")"
    done < "$WORKSPACES_FILE"
  fi

  while IFS= read -r workspace; do
    [ -z "$workspace" ] && continue

    item="$(item_name "$workspace")"
    icon="$(workspace_icon "$workspace")"
    label="$(workspace_label "$workspace")"

    set -- "$@" \
      --add item "$item" left \
      --set "$item" \
        icon="$icon" \
        icon.padding_left=6 \
        icon.padding_right=4 \
        label="$label" \
        label.padding_left=2 \
        label.padding_right=6 \
        background.drawing=on \
        background.color=$BG \
        click_script="aerospace workspace '$workspace'"

    if [ "$focused" = "$workspace" ]; then
      set -- "$@" \
        --set "$item" \
          background.color=$BLUE \
          icon.color=$GREEN \
          label.color=$GREEN
    else
      set -- "$@" \
        --set "$item" \
          background.color=$BG \
          icon.color=$FG \
          label.color=$FG
    fi
  done < "$CURRENT_FILE"
elif [ -n "$previous" ] && [ "$previous" != "$focused" ]; then
  set -- "$@" \
    --set "$(item_name "$previous")" \
      background.color=$BG \
      icon.color=$FG \
      label.color=$FG

  [ -n "$focused" ] && set -- "$@" \
    --set "$(item_name "$focused")" \
      background.color=$BLUE \
      icon.color=$GREEN \
      label.color=$GREEN
else
  while IFS= read -r workspace; do
    [ -z "$workspace" ] && continue

    if [ "$focused" = "$workspace" ]; then
      set -- "$@" \
        --set "$(item_name "$workspace")" \
          background.color=$BLUE \
          icon.color=$GREEN \
          label.color=$GREEN
    else
      set -- "$@" \
        --set "$(item_name "$workspace")" \
          background.color=$BG \
          icon.color=$FG \
          label.color=$FG
    fi
  done < "$CURRENT_FILE"
fi

cp "$CURRENT_FILE" "$WORKSPACES_FILE"

[ "$#" -gt 0 ] && sketchybar "$@"
