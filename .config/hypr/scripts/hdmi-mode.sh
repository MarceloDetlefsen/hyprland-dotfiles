#!/bin/bash

MENU_CMD="wofi --dmenu --prompt 'Modo HDMI' --width 360 --height 220"

get_monitors() {
  hyprctl monitors 2>/dev/null | awk '/^Monitor / {gsub(":", "", $2); print $2}'
}

internal_monitor="$(get_monitors | awk '/^(eDP|LVDS|DSI)/ {print; exit}')"
external_monitor="$(get_monitors | awk '!/^(eDP|LVDS|DSI)/ {print; exit}')"

if [ -z "$internal_monitor" ] || [ -z "$external_monitor" ]; then
  set -- $(get_monitors)
  [ -z "$internal_monitor" ] && internal_monitor="${1:-}"
  [ -z "$external_monitor" ] && external_monitor="${2:-}"
fi

CHOICE=$(printf '%s\n' \
  'Espejo (100%)' \
  'Extendido (derecha)' \
  'Solo HDMI' \
  'Solo Laptop' | eval "$MENU_CMD")

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
  'Espejo (100%)')
    [ -n "$internal_monitor" ] && hyprctl keyword monitor "$internal_monitor,preferred,auto,1"
    [ -n "$external_monitor" ] && hyprctl keyword monitor "$external_monitor,preferred,auto,1,mirror,${internal_monitor:-$external_monitor}"
    notify-send "Hyprland" "Modo HDMI: espejo (100%)"
    ;;
  'Extendido (derecha)')
    [ -n "$internal_monitor" ] && hyprctl keyword monitor "$internal_monitor,preferred,auto,1"
    [ -n "$external_monitor" ] && hyprctl keyword monitor "$external_monitor,preferred,auto,1"
    notify-send "Hyprland" "Modo HDMI: extendido"
    ;;
  'Solo HDMI')
    [ -n "$internal_monitor" ] && hyprctl keyword monitor "$internal_monitor,disable"
    [ -n "$external_monitor" ] && hyprctl keyword monitor "$external_monitor,preferred,auto,1"
    notify-send "Hyprland" "Modo HDMI: solo externo"
    ;;
  'Solo Laptop')
    [ -n "$external_monitor" ] && hyprctl keyword monitor "$external_monitor,disable"
    [ -n "$internal_monitor" ] && hyprctl keyword monitor "$internal_monitor,preferred,auto,1"
    notify-send "Hyprland" "Modo HDMI: solo laptop"
    ;;
esac
