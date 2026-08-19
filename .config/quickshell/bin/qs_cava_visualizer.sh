#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/quickshell"
mkdir -p "$cache_dir"
cfg="$cache_dir/cava-visualizer.conf"

source_name="auto"
if command -v pactl >/dev/null 2>&1; then
  default_sink="$(pactl get-default-sink 2>/dev/null | tr -d '\r' || true)"
  if [[ -n "$default_sink" ]]; then
    source_name="${default_sink}.monitor"
  fi
fi

cat > "$cfg" <<'EOF'
[general]
framerate = 30
bars = 16
autosens = 1
scaling = linear

[input]
method = pipewire
source = __SOURCE_NAME__

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 100
bar_delimiter = 59
frame_delimiter = 10
EOF

sed -i "s|__SOURCE_NAME__|$source_name|g" "$cfg"

exec cava -p "$cfg"
