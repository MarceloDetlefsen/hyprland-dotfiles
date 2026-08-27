#!/usr/bin/env bash
set -euo pipefail

trim() {
  tr -d '\r' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

if command -v nmcli >/dev/null 2>&1; then
  dev=$(nmcli -t -f DEVICE,TYPE,STATE dev status 2>/dev/null | awk -F: '$3=="connected" && ($2=="wifi" || $2=="ethernet") {print $1; exit}' || true)
  if [[ -n "${dev:-}" ]]; then
    conn=$(nmcli -g GENERAL.CONNECTION dev show "$dev" 2>/dev/null | head -n1 | trim || true)
    if [[ -n "${conn:-}" && "$conn" != "--" ]]; then
      echo "$conn"
      exit 0
    fi
  fi

  conn=$(nmcli -t -f IN-USE,SSID dev wifi list 2>/dev/null | awk -F: '$1=="*" {print $2; exit}' | trim || true)
  if [[ -n "${conn:-}" ]]; then
    echo "$conn"
    exit 0
  fi
fi

if command -v iwgetid >/dev/null 2>&1; then
  ssid=$(iwgetid -r 2>/dev/null | trim || true)
  if [[ -n "${ssid:-}" ]]; then
    echo "$ssid"
    exit 0
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
