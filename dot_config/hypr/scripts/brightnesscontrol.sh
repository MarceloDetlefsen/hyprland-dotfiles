#!/usr/bin/env sh

set -eu

current_perc="$(brightnessctl info | awk -F'[()%]' '/Current/ {print $2; exit}')"
[ -n "$current_perc" ] || current_perc=0

case "${1:-}" in
  i)
    brightnessctl set +5% >/dev/null
    ;;
  d)
    if [ "$current_perc" -le 5 ]; then
      brightnessctl set 1% >/dev/null
    else
      brightnessctl set 5%- >/dev/null
    fi
    ;;
  *)
    echo "Usage: $0 {i|d}" >&2
    exit 1
    ;;
esac

new_perc="$(brightnessctl info | awk -F'[()%]' '/Current/ {print $2; exit}')"
mkdir -p "$HOME/.cache/quickshell"
printf '%s\n' "$new_perc" > "$HOME/.cache/quickshell/brightness"
