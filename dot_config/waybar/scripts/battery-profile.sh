#!/usr/bin/env bash

# ignorar cualquier argumento que Waybar pase
set --

BATDIR=$(ls /sys/class/power_supply | grep -E '^BAT' | head -n1)

CAP="?"
STATUS=""

if [ -n "$BATDIR" ]; then
  CAP=$(cat /sys/class/power_supply/$BATDIR/capacity 2>/dev/null)
  STATUS=$(cat /sys/class/power_supply/$BATDIR/status 2>/dev/null)
fi

ICON="󰁽"
case "$CAP" in
  0*|1*|2*) ICON="󰂎" ;;
  3*|4*)   ICON="󰁺" ;;
  5*|6*)   ICON="󰁻" ;;
  7*|8*)   ICON="󰁼" ;;
esac

echo "$ICON $CAP%"
