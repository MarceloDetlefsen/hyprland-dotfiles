#!/usr/bin/env bash

set -euo pipefail

# Usa el LED que ya sabes que tu teclado expone y enciende bien.
LED_DEVICE="${MUTE_LED_DEVICE:-input3::capslock}"

set_led_state() {
  local muted="$1"

  if brightnessctl -d "$LED_DEVICE" set "$muted" >/dev/null 2>&1; then
    return 0
  fi

  return 0
}

sync_led() {
  local mute_state

  mute_state="$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')"
  if [ "$mute_state" = "yes" ]; then
    set_led_state 1
  else
    set_led_state 0
  fi
}

case "${1:-}" in
  --sync)
    sync_led
    ;;
  *)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    sync_led
    ;;
esac
