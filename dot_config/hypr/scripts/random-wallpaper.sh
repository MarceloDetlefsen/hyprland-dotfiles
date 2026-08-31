#!/bin/bash

WALLDIR="$HOME/wallpapers"
TARGET="${1:-}"

if [ -n "$TARGET" ]; then
  [ -f "$TARGET" ] || exit 1
  RANDOM_WALL="$TARGET"
  THEME_ARGS="--no-reload"
else
  RANDOM_WALL=$(find "$WALLDIR" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    | shuf -n 1)
  THEME_ARGS=""
fi

[ -z "$RANDOM_WALL" ] && exit 1

hyprctl hyprpaper preload "$RANDOM_WALL"
sleep 0.15
hyprctl hyprpaper wallpaper eDP-1,"$RANDOM_WALL"

THEME_SCRIPT="$HOME/.config/hypr/scripts/apply-theme.sh"
if [ -x "$THEME_SCRIPT" ]; then
  "$THEME_SCRIPT" $THEME_ARGS "$RANDOM_WALL"
fi
