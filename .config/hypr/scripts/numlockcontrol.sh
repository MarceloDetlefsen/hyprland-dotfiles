#!/usr/bin/env sh

set -eu

NUMLOCK_STATE_FILE="$HOME/.cache/quickshell/numlock"

ensure_cache_dir() {
  mkdir -p "$HOME/.cache/quickshell"
}

read_state() {
  if [ -f "$NUMLOCK_STATE_FILE" ]; then
    tr -d '[:space:]' < "$NUMLOCK_STATE_FILE"
    return 0
  fi

  printf '%s\n' "${1:-on}"
}

write_state() {
  ensure_cache_dir
  printf '%s\n' "$1" > "$NUMLOCK_STATE_FILE"
}

case "${1:-toggle}" in
  sync)
    write_state on
    ;;
  on|off|toggle)
    case "$1" in
      on|off)
        write_state "$1"
        ;;
      toggle)
        current="$(read_state on)"
        if [ "$current" = "on" ]; then
          write_state off
        else
          write_state on
        fi
        ;;
    esac
    ;;
  *)
    printf 'Usage: %s {on|off|toggle|sync}\n' "$0" >&2
    exit 1
    ;;
esac
