#!/bin/bash

MENU_CMD="wofi --dmenu --prompt 'Modo HDMI' --width 360 --height 220"

CHOICE=$(printf '%s\n' \
  'Espejo (100%)' \
  'Extendido (derecha)' \
  'Solo HDMI' \
  'Solo Laptop' | eval "$MENU_CMD")

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
  'Espejo (100%)')
    hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1,mirror,eDP-1"
    notify-send "Hyprland" "Modo HDMI: espejo (100%)"
    ;;
  'Extendido (derecha)')
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,1920x0,1"
    notify-send "Hyprland" "Modo HDMI: extendido"
    ;;
  'Solo HDMI')
    hyprctl keyword monitor "eDP-1,disable"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
    notify-send "Hyprland" "Modo HDMI: solo externo"
    ;;
  'Solo Laptop')
    hyprctl keyword monitor "HDMI-A-1,disable"
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
    notify-send "Hyprland" "Modo HDMI: solo laptop"
    ;;
esac
