#!/usr/bin/env bash

set -euo pipefail

if pgrep -x bluedevil-wizard >/dev/null 2>&1; then
  pkill -x bluedevil-wizard
  exit 0
fi

if pgrep -x blueman-manager >/dev/null 2>&1; then
  pkill -x blueman-manager
  exit 0
fi

if command -v bluedevil-wizard >/dev/null 2>&1; then
  nohup bluedevil-wizard >/dev/null 2>&1 &
  disown || true
  exit 0
fi

if command -v blueman-manager >/dev/null 2>&1; then
  nohup blueman-manager >/dev/null 2>&1 &
  disown || true
  exit 0
fi

if command -v nm-connection-editor >/dev/null 2>&1; then
  nohup nm-connection-editor >/dev/null 2>&1 &
  disown || true
  exit 0
fi

notify-send "Bluetooth" "No encontré un menú de Bluetooth instalado."
