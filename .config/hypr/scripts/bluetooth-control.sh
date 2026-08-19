#!/usr/bin/env bash

set -euo pipefail

ACTION="${1:-state}"

adapter_path() {
  gdbus call --system \
    --dest org.bluez \
    --object-path / \
    --method org.freedesktop.DBus.ObjectManager.GetManagedObjects 2>/dev/null \
    | grep -o '/org/bluez/hci[0-9]\+' \
    | head -n1
}

ensure_service() {
  if systemctl is-active --quiet bluetooth.service; then
    return 0
  fi

  pkexec systemctl start bluetooth.service >/dev/null 2>&1 \
    || systemctl start bluetooth.service >/dev/null 2>&1 \
    || true
}

get_powered() {
  local adapter="$1"
  busctl --system get-property org.bluez "$adapter" org.bluez.Adapter1 Powered 2>/dev/null \
    | awk '{print $2}'
}

set_powered() {
  local adapter="$1"
  local state="$2"
  busctl --system set-property org.bluez "$adapter" org.bluez.Adapter1 Powered b "$state" >/dev/null 2>&1
}

case "$ACTION" in
  state)
    adapter="$(adapter_path || true)"
    if [ -z "${adapter:-}" ]; then
      printf 'false\n'
      exit 0
    fi

    powered="$(get_powered "$adapter" || true)"
    if [ "$powered" = "true" ]; then
      printf 'true\n'
    else
      printf 'false\n'
    fi
    ;;

  toggle)
    ensure_service

    adapter="$(adapter_path || true)"
    if [ -z "${adapter:-}" ]; then
      notify-send "Bluetooth" "No encontré un adaptador Bluetooth activo."
      exit 0
    fi

    powered="$(get_powered "$adapter" || true)"
    if [ "$powered" = "true" ]; then
      set_powered "$adapter" false
      notify-send "Bluetooth" "Bluetooth desactivado"
    else
      set_powered "$adapter" true
      notify-send "Bluetooth" "Bluetooth activado"
    fi
    ;;

  *)
    echo "Usage: $0 {state|toggle}" >&2
    exit 1
    ;;
esac
