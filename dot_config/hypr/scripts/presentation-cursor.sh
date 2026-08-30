#!/usr/bin/env bash
set -euo pipefail

state_file="${XDG_CACHE_HOME:-$HOME/.cache}/quickshell/presentation_cursor"
mkdir -p "$(dirname "$state_file")"

set_state() {
    printf '%s\n' "$1" >"$state_file"
}

current_state="off"
if [[ -f "$state_file" ]]; then
    current_state="$(tr -d '[:space:]' <"$state_file" | tr '[:upper:]' '[:lower:]' || true)"
fi

action="${1:-toggle}"
case "$action" in
    on)
        set_state on
        ;;
    off)
        set_state off
        ;;
    toggle)
        if [[ "$current_state" == "on" ]]; then
            set_state off
        else
            set_state on
        fi
        ;;
    *)
        echo "Usage: $0 [on|off|toggle]" >&2
        exit 1
        ;;
esac
