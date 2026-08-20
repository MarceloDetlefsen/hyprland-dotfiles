#!/usr/bin/env bash

set -euo pipefail

LOW_NOTIFIED=false
CRITICAL_NOTIFIED=false
LAST_AC_STATE="unknown"

get_ac_state() {
  local ac_dir
  ac_dir="$(ls /sys/class/power_supply | grep -E '^(AC|ACAD|ADP|Mains)' | head -n1 || true)"

  if [[ -n "$ac_dir" && -r "/sys/class/power_supply/$ac_dir/online" ]]; then
    if [[ "$(cat "/sys/class/power_supply/$ac_dir/online" 2>/dev/null || echo 0)" == "1" ]]; then
      echo "online"
    else
      echo "offline"
    fi
    return
  fi

  local status
  status="$(acpi -b 2>/dev/null || true)"
  if echo "$status" | grep -Eq 'Charging|Full'; then
    echo "online"
  else
    echo "offline"
  fi
}

while true; do
  BATTERY_LEVEL="$(acpi -b | grep -P -o '[0-9]+(?=%)' | head -n1 || echo 0)"
  STATUS="$(acpi -b | grep -o 'Discharging' || true)"
  AC_STATE="$(get_ac_state)"

  if [[ "$AC_STATE" == "online" && "$LAST_AC_STATE" != "online" ]]; then
    if command -v powerprofilesctl >/dev/null 2>&1; then
      powerprofilesctl set performance 2>/dev/null || true
    fi
    notify-send "Energía" "Cargador conectado: modo Rendimiento activado"
  fi

  LAST_AC_STATE="$AC_STATE"

  if [[ "$STATUS" == "Discharging" ]]; then
    if [[ "$BATTERY_LEVEL" -le 20 && "$BATTERY_LEVEL" -gt 10 && "$LOW_NOTIFIED" == false ]]; then
      notify-send -u normal "⚠️ Batería baja" "Te queda ${BATTERY_LEVEL}%"
      LOW_NOTIFIED=true
    fi

    if [[ "$BATTERY_LEVEL" -le 10 && "$CRITICAL_NOTIFIED" == false ]]; then
      notify-send -u critical "🚨 Batería crítica" "Te queda ${BATTERY_LEVEL}%"
      CRITICAL_NOTIFIED=true
    fi
  else
    LOW_NOTIFIED=false
    CRITICAL_NOTIFIED=false
  fi

  sleep 60
done
