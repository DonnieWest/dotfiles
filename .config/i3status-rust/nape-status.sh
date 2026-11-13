#!/usr/bin/env bash
# Read the Nape Pro orientation and active DPI for i3status-rust.
set -u

VID_PID='HID_ID=0003:00003434:00000440'
USAGE_DESCRIPTOR='0660ff0961' # Usage page FF60, usage 61
ICON_BASE=$((16#E900))

unavailable() {
    printf 'Nape: %s\n' "$1"
}

find_nape_hidraw() {
    local sysdev descriptor
    for sysdev in /sys/class/hidraw/hidraw*; do
        [[ -r "$sysdev/device/uevent" && -r "$sysdev/device/report_descriptor" ]] || continue
        grep -qx "$VID_PID" "$sysdev/device/uevent" || continue
        descriptor=$(od -An -v -tx1 "$sysdev/device/report_descriptor" 2>/dev/null | tr -d ' \n') || continue
        if [[ $descriptor == *"$USAGE_DESCRIPTOR"* ]]; then
            printf '/dev/%s\n' "${sysdev##*/}"
            return 0
        fi
    done
    return 1
}

query() {
    local command=$1 argument=${2-} padding format octet response_text
    local -a response=()

    # hidraw expects a report-ID byte (zero for this unnumbered interface),
    # followed by the same 32-byte request payload used by HIDAPI.
    format='\0\247'
    printf -v octet '\\%03o' "$command"
    format+="$octet"
    if [[ -n $argument ]]; then
        printf -v octet '\\%03o' "$argument"
        format+="$octet"
        padding=29
    else
        padding=30
    fi
    for ((i=0; i<padding; i++)); do format+='\0'; done

    # One printf call is important: hidraw rejects short partial reports.
    printf "$format" >&3 || return 1
    response_text=$(timeout 1 dd bs=32 count=1 status=none <&3 2>/dev/null | od -An -v -tu1) || return 1
    read -r -a response <<< "$response_text"
    [[ ${#response[@]} -ge 4 && ${response[0]} -eq 167 && ${response[1]} -eq $command ]] || return 1
    printf '%s\n' "${response[*]}"
}

main() {
    local hidraw orientation_step orientation slot dpi_response dpi icon_escape
    local -a orientation_reply slot_reply dpi_reply

    hidraw=$(find_nape_hidraw) || { unavailable 'device not found'; return; }
    if ! exec 3<> "$hidraw"; then
        unavailable 'device cannot be opened'
        return
    fi
    trap 'exec 3>&-' EXIT

    orientation_reply=($(query 32)) || { unavailable 'query failed'; return; }
    slot_reply=($(query 33)) || { unavailable 'query failed'; return; }
    orientation_step=$((orientation_reply[2] % 8))
    orientation=$((orientation_step * 45))
    slot=${slot_reply[2]}
    dpi_response=$(query 36 "$slot") || { unavailable 'query failed'; return; }
    dpi_reply=($dpi_response)
    dpi=$((dpi_reply[2] + (dpi_reply[3] << 8)))

    printf -v icon_escape '\\u%04x' "$((ICON_BASE + orientation_step))"
    printf '%b %d° | %d DPI\n' "$icon_escape" "$orientation" "$dpi"
}

main
