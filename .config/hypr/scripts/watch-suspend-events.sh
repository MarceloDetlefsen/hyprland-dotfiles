#!/usr/bin/env bash

set -euo pipefail

lock_file="${XDG_RUNTIME_DIR:-/tmp}/hypr-suspend-watcher.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'" |
while read -r line; do
  if [[ "$line" == *"boolean true"* ]]; then
    /home/chelo/.config/hypr/scripts/lock-session.sh
  fi
done
