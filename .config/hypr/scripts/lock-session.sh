#!/usr/bin/env bash

set -euo pipefail

if command -v loginctl >/dev/null 2>&1; then
  loginctl lock-session >/dev/null 2>&1 || true
fi

if command -v hyprlock >/dev/null 2>&1 && ! pgrep -x hyprlock >/dev/null 2>&1; then
  hyprlock >/dev/null 2>&1 &
fi
