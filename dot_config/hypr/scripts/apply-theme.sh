#!/bin/bash

set -euo pipefail

WALLPAPER="${1:-}"

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    echo "apply-theme: missing wallpaper path" >&2
    exit 1
fi

mkdir -p \
    "$HOME/.config/hypr/generated" \
    "$HOME/.config/kitty/generated"

if ! command -v matugen >/dev/null 2>&1; then
    echo "apply-theme: matugen is not installed; wallpaper changed, theme not regenerated" >&2
    exit 0
fi

matugen image "$WALLPAPER" -m dark --source-color-index 0

PALETTE_FILE="$HOME/.config/quickshell/palette.json"
SETTINGS_FILE="$HOME/.config/quickshell/lib/usersettings.json"

if command -v jq >/dev/null 2>&1 && [ -f "$PALETTE_FILE" ] && [ -f "$SETTINGS_FILE" ]; then
    tmp="$(mktemp)"
    jq --slurpfile pal "$PALETTE_FILE" '
        .customAccent = ($pal[0].accent // .customAccent)
        | .customBg = ($pal[0].background // .customBg)
        | .taskbarAccent = ($pal[0].accent // .taskbarAccent)
        | .borderFrameColor = ($pal[0].outline // .borderFrameColor)
        | .powerMenuLifeDark = ($pal[0].accent // .powerMenuLifeDark)
        | .powerMenuLifeLight = ($pal[0].secondary // .powerMenuLifeLight)
        | .powerMenuCassiniDark = ($pal[0].primary_container // .powerMenuCassiniDark)
        | .powerMenuCassiniLight = ($pal[0].tertiary_container // .powerMenuCassiniLight)
    ' "$SETTINGS_FILE" > "$tmp"
    mv "$tmp" "$SETTINGS_FILE"
fi

if pgrep -x kitty >/dev/null 2>&1; then
    pkill -SIGUSR1 kitty >/dev/null 2>&1 || true
fi
hyprctl reload >/dev/null 2>&1 || true

if pgrep -x qs >/dev/null 2>&1; then
    pkill -x qs >/dev/null 2>&1 || true
    sleep 0.3
    if command -v qs >/dev/null 2>&1; then
        nohup qs >/dev/null 2>&1 &
    fi
fi
