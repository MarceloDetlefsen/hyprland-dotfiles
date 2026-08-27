#!/usr/bin/env bash
set -euo pipefail

if command -v nmcli >/dev/null 2>&1; then
  connected_ethernet=$(nmcli -t -f TYPE,STATE dev status 2>/dev/null | awk -F: '$1=="ethernet" && $2=="connected" {print 1; exit}' || true)
  if [[ "${connected_ethernet:-0}" == "1" ]]; then
    echo "Ethernet"
    exit 0
  fi

  wifi_enabled=$(nmcli -t -f WIFI g 2>/dev/null | head -n1 || true)
  if [[ "$wifi_enabled" == "enabled" ]]; then
    ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1=="yes" {print $2; exit}' || true)
    if [[ -n "${ssid:-}" ]]; then
      echo "$ssid"
      exit 0
    fi

    conn=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active 2>/dev/null | awk -F: '$2=="802-11-wireless" {print $1; exit}' || true)
    if [[ -n "${conn:-}" ]]; then
      echo "$conn"
      exit 0
    fi
  fi
fi

if command -v iw >/dev/null 2>&1; then
  while IFS= read -r iface; do
    [ -n "$iface" ] || continue
    ssid=$(iw dev "$iface" link 2>/dev/null | awk -F': ' '/SSID/ {print $2; exit}' || true)
    if [[ -n "${ssid:-}" && "$ssid" != "Not connected." ]]; then
      echo "$ssid"
      exit 0
    fi
  done < <(iw dev 2>/dev/null | awk '/Interface/ {print $2}')
fi

route_dev=$(ip route show default 2>/dev/null | awk 'NR==1 {for (i=1; i<=NF; i++) if ($i=="dev") {print $(i+1); exit}}' || true)
if [[ -n "${route_dev:-}" ]]; then
  case "$route_dev" in
    wl*|wlan*|wifi*)
      echo "Wi-Fi"
      exit 0
      ;;
    *)
      echo "Ethernet"
      exit 0
      ;;
  esac
fi

echo "Network"
