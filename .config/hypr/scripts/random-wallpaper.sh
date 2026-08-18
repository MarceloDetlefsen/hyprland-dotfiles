#!/bin/bash

WALLDIR="$HOME/wallpapers"
mapfile -t MONITORS < <(hyprctl monitors 2>/dev/null | awk '/^Monitor / {gsub(":", "", $2); print $2}')

RANDOM_WALL=$(find "$WALLDIR" -type f \
  \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
  | shuf -n 1)

[ -z "$RANDOM_WALL" ] && exit 1

hyprctl hyprpaper preload "$RANDOM_WALL"
sleep 0.15
if [ "${#MONITORS[@]}" -eq 0 ]; then
  hyprctl hyprpaper wallpaper ",$RANDOM_WALL"
else
  for monitor in "${MONITORS[@]}"; do
    hyprctl hyprpaper wallpaper "$monitor,$RANDOM_WALL"
  done
fi
