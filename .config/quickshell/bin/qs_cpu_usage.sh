#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/quickshell"
state_file="$cache_dir/cpu_prev"
mkdir -p "$cache_dir"

read -r _ user nice system idle iowait irq softirq steal guest guest_nice < <(
  awk '/^cpu / {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11; exit}' /proc/stat
)

idle_all=$((idle + iowait))
non_idle=$((user + nice + system + irq + softirq + steal))
total=$((idle_all + non_idle))

cpu=0
if [[ -f "$state_file" ]]; then
  read -r prev_total prev_idle < "$state_file" || true
  total_delta=$((total - prev_total))
  idle_delta=$((idle_all - prev_idle))
  if (( total_delta > 0 )); then
    cpu=$(( (100 * (total_delta - idle_delta)) / total_delta ))
  fi
fi

printf '%s %s\n' "$total" "$idle_all" > "$state_file"
echo "$cpu"
