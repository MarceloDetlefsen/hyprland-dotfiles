#!/usr/bin/env bash

set -euo pipefail

wifi_high="󰤨"
wifi_mid="󰤢"
wifi_low="󰤟"
wifi_none="󰤭"
eth_icon="󰈀"

line="$(
  nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev status 2>/dev/null || true \
    | awk -F: '$3=="connected"{print; exit}'
)"

if [ -z "${line:-}" ]; then
  printf '%s 0%%\n' "$wifi_none"
  exit 0
fi

device="$(printf '%s\n' "$line" | awk -F: '{print $1}')"
type="$(printf '%s\n' "$line" | awk -F: '{print $2}')"

if [ "$type" = "ethernet" ]; then
  printf '%s 100%%\n' "$eth_icon"
  exit 0
fi

signal="$(
  nmcli -t -f IN-USE,SIGNAL dev wifi list 2>/dev/null || true \
    | awk -F: '$1=="*"{print $2; exit}'
)"

signal="${signal:-0}"

if [ "$signal" -ge 75 ]; then
  icon="$wifi_high"
elif [ "$signal" -ge 45 ]; then
  icon="$wifi_mid"
elif [ "$signal" -ge 15 ]; then
  icon="$wifi_low"
else
  icon="$wifi_none"
fi

printf '%s %s%%\n' "$icon" "$signal"
