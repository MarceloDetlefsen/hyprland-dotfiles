#!/usr/bin/env bash
set -euo pipefail

mem_total=$(awk '/^MemTotal:/ {print $2; exit}' /proc/meminfo)
mem_avail=$(awk '/^MemAvailable:/ {print $2; exit}' /proc/meminfo)

if [[ -z "${mem_total:-}" || -z "${mem_avail:-}" || "$mem_total" -le 0 ]]; then
  echo 0
  exit 0
fi

used=$(( (mem_total - mem_avail) * 100 / mem_total ))
echo "$used"
