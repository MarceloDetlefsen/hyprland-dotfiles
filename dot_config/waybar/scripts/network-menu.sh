#!/usr/bin/env bash

set -euo pipefail

if ! command -v wofi >/dev/null 2>&1; then
  notify-send "Red" "wofi no está instalado"
  exit 1
fi

if ! command -v nmcli >/dev/null 2>&1; then
  notify-send "Red" "nmcli no está instalado"
  exit 1
fi

choice="$(
  printf '%s\n' \
    "Wi-Fi: activar/desactivar" \
    "Conectar a red" \
    "Estado" \
    "Abrir configuración" \
    | wofi --dmenu --prompt "Red" --width 360 --height 240
)"

[ -n "$choice" ] || exit 0

case "$choice" in
  "Wi-Fi: activar/desactivar")
    if nmcli radio wifi | grep -q '^enabled$'; then
      nmcli radio wifi off
      notify-send "Red" "Wi-Fi desactivado"
    else
      nmcli radio wifi on
      notify-send "Red" "Wi-Fi activado"
    fi
    ;;
  "Conectar a red")
    ssid="$(
      nmcli -f SSID,SIGNAL dev wifi list --rescan yes | awk 'NR>1 && $1 != "" {print $1 "  (" $2 "%)"}' | wofi --dmenu --prompt "SSID" --width 420 --height 260
    )"
    [ -n "$ssid" ] || exit 0
    nmcli dev wifi connect "${ssid%%  (*}"
    ;;
  "Estado")
    notify-send "Red" "$(nmcli -t -f DEVICE,TYPE,STATE dev status)"
    ;;
  "Abrir configuración")
    exec nm-connection-editor
    ;;
esac
