#!/usr/bin/env bash

set -euo pipefail

if command -v hyprlock >/dev/null 2>&1 && ! pgrep -x hyprlock >/dev/null 2>&1; then
  hyprlock >/dev/null 2>&1 &
fi
