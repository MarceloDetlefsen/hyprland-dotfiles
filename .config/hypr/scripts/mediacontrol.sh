#!/usr/bin/env sh

set -eu

playerctl play-pause
sleep 0.2

status="$(playerctl status 2>/dev/null || true)"
title="$(playerctl metadata title 2>/dev/null || true)"
artist="$(playerctl metadata artist 2>/dev/null || true)"

mkdir -p "$HOME/.cache/quickshell"
if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
  printf '%s\n%s\n%s\n' "$status" "$title" "$artist" > "$HOME/.cache/quickshell/media"
else
  : > "$HOME/.cache/quickshell/media"
fi

if command -v notify-send >/dev/null 2>&1; then
  if [ "$status" = "Playing" ]; then
    notify-send -c media "Playing" "${title}${artist:+ - $artist}"
  elif [ "$status" = "Paused" ]; then
    notify-send -c media "Paused" "$title"
  fi
fi
