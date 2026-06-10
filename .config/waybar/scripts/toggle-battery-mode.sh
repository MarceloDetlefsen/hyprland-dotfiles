#!/usr/bin/env bash

set -euo pipefail

if ! command -v powerprofilesctl >/dev/null 2>&1; then
  notify-send "Power Profile" "powerprofilesctl no está instalado"
  exit 1
fi

current_profile=$(powerprofilesctl get 2>/dev/null || true)

case "$current_profile" in
  balanced)
    next_profile="performance"
    ;;
  performance)
    next_profile="power-saver"
    ;;
  power-saver)
    next_profile="balanced"
    ;;
  *)
    next_profile="balanced"
    ;;
esac

powerprofilesctl set "$next_profile"

case "$next_profile" in
  performance)
    label="Rendimiento"
    ;;
  balanced)
    label="Balanceado"
    ;;
  power-saver)
    label="Ahorro"
    ;;
esac

notify-send "Energía" "Modo $label activado"

# Forzar refresco inmediato del módulo custom/battery (signal 8)
pkill -RTMIN+8 waybar 2>/dev/null || true
