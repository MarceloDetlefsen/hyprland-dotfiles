#!/usr/bin/env bash

set -euo pipefail

MENU_CMD="wofi --dmenu --prompt 'Salida de audio' --width 360 --height 220"

list_sinks() {
  pactl list short sinks | while IFS= read -r sink_line; do
    sink_name="$(printf '%s\n' "$sink_line" | awk '{print $2}')"
    sink_desc="$(
      pactl list sinks | awk -v sink="$sink_name" '
        $1 == "Name:" && $2 == sink { in_sink=1; next }
        /^Sink #[0-9]+/ && in_sink { exit }
        in_sink && $1 == "Description:" {
          sub(/^Description: /, "", $0)
          print
          exit
        }
      '
    )"
    printf '%s\t%s\n' "$sink_name" "${sink_desc:-$sink_name}"
  done
}

move_streams() {
  local target="$1"
  pactl list short sink-inputs | awk '{print $1}' | while read -r input_id; do
    [ -n "$input_id" ] && pactl move-sink-input "$input_id" "$target" || true
  done
}

choose_sink_manually() {
  local choice sink_name
  choice="$(
    list_sinks | eval "$MENU_CMD"
  )"

  [ -n "$choice" ] || exit 0
  printf '%s\n' "${choice%%$'\t'*}"
}

first_sink() {
  pactl list short sinks | awk 'NR==1 { print $2 }'
}

CHOICE="$(
  printf '%s\n' \
    'Tele / Compu' \
    'Elegir manualmente' \
    'Recuperar audio' | eval "$MENU_CMD"
)"

[ -n "$CHOICE" ] || exit 0

case "$CHOICE" in
  "Elegir manualmente")
    SINK="$(choose_sink_manually || true)"
    ;;
  "Recuperar audio")
    SINK="$(first_sink || true)"
    ;;
  "Tele / Compu")
    SINK="$(choose_sink_manually || true)"
    ;;
esac

if [ -z "${SINK:-}" ]; then
  notify-send "Audio" "No encontré una salida. Abriendo lista completa."
  SINK="$(choose_sink_manually || true)"
fi

[ -n "${SINK:-}" ] || exit 0

pactl set-default-sink "$SINK"
pactl set-sink-mute "$SINK" 0 || true
pactl set-sink-volume "$SINK" 100% || true
move_streams "$SINK"
notify-send "Audio" "Salida cambiada a: $CHOICE"
