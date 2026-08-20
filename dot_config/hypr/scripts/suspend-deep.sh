#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
"$script_dir/lock-session.sh"

sleep 2

exec systemctl suspend
