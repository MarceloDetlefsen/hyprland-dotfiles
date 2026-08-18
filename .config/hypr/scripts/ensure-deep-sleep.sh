#!/usr/bin/env bash

set -euo pipefail

mem_sleep=/sys/power/mem_sleep

if [[ ! -r "$mem_sleep" ]] || grep -q '\[deep\]' "$mem_sleep"; then
  exit 0
fi

if command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
  printf 'deep\n' | sudo tee "$mem_sleep" >/dev/null
  exit 0
fi

if command -v pkexec >/dev/null 2>&1; then
  pkexec sh -c "printf deep > '$mem_sleep'" >/dev/null 2>&1 || true
fi
