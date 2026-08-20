#!/usr/bin/env sh

set -eu

if command -v pamixer >/dev/null 2>&1; then
  audio_get_volume() {
    pamixer --get-volume
  }
  audio_get_mute() {
    pamixer --get-mute
  }
  audio_volume_up() {
    pamixer -i 5
  }
  audio_volume_down() {
    pamixer -d 5
  }
  audio_toggle_mute() {
    pamixer -t
  }
else
  audio_get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | awk 'match($0, /([0-9]+)%/, m) { print m[1]; exit }'
  }
  audio_get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'
  }
  audio_volume_up() {
    pactl set-sink-volume @DEFAULT_SINK@ +5%
  }
  audio_volume_down() {
    pactl set-sink-volume @DEFAULT_SINK@ -5%
  }
  audio_toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
  }
fi

case "${1:-}" in
  i) audio_volume_up ;;
  d) audio_volume_down ;;
  m) audio_toggle_mute ;;
  *) echo "Usage: $0 {i|d|m}" >&2; exit 1 ;;
esac

vol="$(audio_get_volume)"
is_muted="$(audio_get_mute)"

mkdir -p "$HOME/.cache/quickshell"
printf '%s:%s\n' "$vol" "$is_muted" > "$HOME/.cache/quickshell/volume"

if [ "$is_muted" = "true" ] || [ "$is_muted" = "yes" ]; then
  printf '\n' > "$HOME/.cache/quickshell/media"
fi
