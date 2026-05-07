#!/usr/bin/env sh

BG=0xff03090e
FG=0xffe6f9f7
GREEN=0xff50fa7b
BLUE=0xff0c2132

CACHE_DIR="${TMPDIR:-/tmp}/sketchybar-aerospace"
WORKSPACES_FILE="$CACHE_DIR/workspaces"
CURRENT_FILE="$CACHE_DIR/workspaces.current"

mkdir -p "$CACHE_DIR"

item_name() {
  printf 'aerospace.%s' "$(printf '%s' "$1" | tr -c '[:alnum:]_-' '_')"
}

workspace_label() {
  case "$1" in
    1) printf 'Browser' ;;
    2) printf 'Chat' ;;
    3) printf 'Terminal' ;;
    4) printf 'Emulator' ;;
    5|6|7|8|9|10) printf 'Code' ;;
    *) printf '%s' "$1" ;;
  esac
}

aerospace list-workspaces --all 2>/dev/null > "$CURRENT_FILE"

if [ ! -s "$CURRENT_FILE" ]; then
  focused_fallback="$(aerospace list-workspaces --focused 2>/dev/null)"
  [ -n "$focused_fallback" ] && printf '%s\n' "$focused_fallback" > "$CURRENT_FILE"
fi

focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

set --

# A direct call from sketchybarrc is a rebuild. Remove cached items first so
# reloads do not depend on sketchybar retaining prior item state.
if [ -z "${SENDER:-}" ]; then
  # Clean up the previous static 1..10 items from the pre-dynamic config.
  for legacy_workspace in 1 2 3 4 5 6 7 8 9 10; do
    set -- "$@" --remove "$legacy_workspace"
  done

  if [ -f "$WORKSPACES_FILE" ]; then
    while IFS= read -r workspace; do
      [ -n "$workspace" ] && set -- "$@" --remove "$(item_name "$workspace")"
    done < "$WORKSPACES_FILE"
  fi
fi

if [ -f "$WORKSPACES_FILE" ] && [ -n "${SENDER:-}" ]; then
  while IFS= read -r workspace; do
    if [ -n "$workspace" ] && ! grep -Fxq "$workspace" "$CURRENT_FILE"; then
      set -- "$@" --remove "$(item_name "$workspace")"
    fi
  done < "$WORKSPACES_FILE"
fi

while IFS= read -r workspace; do
  [ -z "$workspace" ] && continue

  item="$(item_name "$workspace")"
  label="$(workspace_label "$workspace")"

  if [ ! -f "$WORKSPACES_FILE" ] || [ -z "${SENDER:-}" ] || ! grep -Fxq "$workspace" "$WORKSPACES_FILE"; then
    set -- "$@" \
      --add item "$item" left \
      --set "$item" \
        icon="$workspace" \
        icon.padding_left=10 \
        icon.padding_right=6 \
        label="$label" \
        label.padding_left=4 \
        label.padding_right=10 \
        background.drawing=on \
        background.color=$BG \
        click_script="aerospace workspace '$workspace'" \
        script="$0" \
      --subscribe "$item" aerospace_workspace_change
  fi

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

cp "$CURRENT_FILE" "$WORKSPACES_FILE"

[ "$#" -gt 0 ] && sketchybar "$@"
