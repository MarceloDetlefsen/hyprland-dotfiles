#!/usr/bin/env bash
set -euo pipefail

connected_ethernet=$(nmcli -t -f TYPE,STATE dev status 2>/dev/null | awk -F: '$1=="ethernet" && $2=="connected" {print 1; exit}')
if [[ "${connected_ethernet:-0}" == "1" ]]; then
  echo 100
  exit 0
fi

wifi_enabled=$(nmcli -t -f WIFI g 2>/dev/null | head -n1 || true)
if [[ "$wifi_enabled" != "enabled" ]]; then
  echo 0
  exit 0
fi

signal=$(nmcli -t -f IN-USE,SIGNAL dev wifi list 2>/dev/null | awk -F: '$1=="*" {print $2; exit}')
if [[ -n "${signal:-}" ]]; then
  echo "$signal"
  exit 0
fi

state=$(nmcli -t -f CONNECTIVITY general 2>/dev/null | head -n1 || true)
case "$state" in
  full) echo 100 ;;
  limited|portal) echo 50 ;;
  none|"") echo 0 ;;
  *) echo 75 ;;
esac
