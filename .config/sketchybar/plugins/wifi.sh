#!/usr/bin/env sh

network_info="$(scutil --nwi 2>/dev/null)"
IP_ADDRESS="$(printf '%s\n' "$network_info" | awk -F: '/address/ { gsub(/[[:space:]]/, "", $2); print $2; exit }')"
IS_VPN="$(printf '%s\n' "$network_info" | awk '/utun/ { print $1; exit }')"

if [ -n "$IS_VPN" ]; then
	ICON=""
	LABEL="VPN"
elif [ -n "$IP_ADDRESS" ]; then
	ICON=""
	LABEL=$IP_ADDRESS
else
	ICON=""
	LABEL="Not Connected"
fi

sketchybar --set "$NAME" \
	icon="$ICON" \
	label="$LABEL"
