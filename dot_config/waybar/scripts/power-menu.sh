#!/usr/bin/env bash

set -euo pipefail

if ! command -v wofi >/dev/null 2>&1; then
  notify-send "Energía" "wofi no está instalado"
  exit 1
fi

if ! command -v powerprofilesctl >/dev/null 2>&1; then
  notify-send "Energía" "powerprofilesctl no está instalado"
  exit 1
fi

current_profile="$(powerprofilesctl get 2>/dev/null || echo balanced)"

perf_prefix="  "
bal_prefix="  "
save_prefix="  "

case "$current_profile" in
  performance) perf_prefix="✓ " ;;
  balanced) bal_prefix="✓ " ;;
  power-saver) save_prefix="✓ " ;;
esac

choice=$(printf "%s⚡ Rendimiento\n%s⚖️ Balanceado\n%s🌿 Ahorro de energía\n🔋 Estado" \
  "$perf_prefix" "$bal_prefix" "$save_prefix" | \
  wofi --dmenu --prompt "Perfil de energía" --width 360 --height 240)

set_profile() {
  local profile="$1"
  local label="$2"

  powerprofilesctl set "$profile"
  notify-send "Energía" "Modo $label activado"
  pkill -RTMIN+8 waybar 2>/dev/null || true
}

case "$choice" in
  *"⚡ Rendimiento")
    set_profile "performance" "Rendimiento"
    ;;
  *"⚖️ Balanceado")
    set_profile "balanced" "Balanceado"
    ;;
  *"🌿 Ahorro de energía")
    set_profile "power-saver" "Ahorro"
    ;;
  "🔋 Estado")
    bat_device="$(upower -e | grep BAT | head -n1 || true)"
    if [[ -n "$bat_device" ]]; then
      details="$(upower -i "$bat_device" | grep -E 'state|percentage|time to empty|time to full' || true)"
      notify-send "Batería" "${details:-No se pudo leer el estado}"
    else
      notify-send "Batería" "No se detectó batería"
    fi
    ;;
esac
