#!/bin/bash

WALLDIR="$HOME/wallpapers"

RANDOM_WALL=$(find "$WALLDIR" -type f \
  \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
  | shuf -n 1)

[ -z "$RANDOM_WALL" ] && exit 1

hyprctl hyprpaper preload "$RANDOM_WALL"
sleep 0.15
hyprctl hyprpaper wallpaper eDP-1,"$RANDOM_WALL"
