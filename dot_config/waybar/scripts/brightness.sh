#!/usr/bin/env bash

set -euo pipefail

pct="$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '% ' || printf '0')"
pct="${pct:-0}"

if [ "$pct" -lt 25 ]; then
  icon="󰃞"
elif [ "$pct" -lt 75 ]; then
  icon="󰃟"
else
  icon="󰃠"
fi

printf '%s %s%%\n' "$icon" "$pct"
