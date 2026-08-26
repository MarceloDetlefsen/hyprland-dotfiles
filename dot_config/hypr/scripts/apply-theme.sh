#!/bin/bash

set -euo pipefail

WALLPAPER="${1:-}"

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    echo "apply-theme: missing wallpaper path" >&2
    exit 1
fi

mkdir -p \
    "$HOME/.config/hypr/generated" \
    "$HOME/.config/kitty/generated" \
    "$HOME/.local/share/color-schemes"

if ! command -v matugen >/dev/null 2>&1; then
    echo "apply-theme: matugen is not installed; wallpaper changed, theme not regenerated" >&2
    exit 0
fi

matugen image "$WALLPAPER" -m dark --source-color-index 0

generate_kde_scheme() {
    local kitty_colors="$HOME/.config/kitty/generated/colors.conf"
    local scheme_file="$HOME/.local/share/color-schemes/Matugen.colors"
    local tmp

    [ -f "$kitty_colors" ] || return 0

    color_hex() {
        awk -v key="$1" '$1 == key { print $2; exit }' "$kitty_colors"
    }

    hex_to_rgb() {
        local hex="${1#\#}"
        [ "${#hex}" -eq 6 ] || return 1
        printf '%d,%d,%d' \
            "$((16#${hex:0:2}))" \
            "$((16#${hex:2:2}))" \
            "$((16#${hex:4:2}))"
    }

    local bg fg cursor sel_fg sel_bg url c0 c1 c2 c3 c4 c5 c6 c7
    bg="$(color_hex background)"
    fg="$(color_hex foreground)"
    cursor="$(color_hex cursor)"
    sel_fg="$(color_hex selection_foreground)"
    sel_bg="$(color_hex selection_background)"
    url="$(color_hex url_color)"
    c0="$(color_hex color0)"
    c1="$(color_hex color1)"
    c2="$(color_hex color2)"
    c3="$(color_hex color3)"
    c4="$(color_hex color4)"
    c5="$(color_hex color5)"
    c6="$(color_hex color6)"
    c7="$(color_hex color7)"

    [ -n "$bg" ] && [ -n "$fg" ] && [ -n "$cursor" ] || return 0

    tmp="$(mktemp)"
    cat > "$tmp" <<EOF
[ColorEffects:Disabled]
Color=56,56,56
ColorAmount=0
ColorEffect=0
ContrastAmount=0.65
ContrastEffect=1
IntensityAmount=0.1
IntensityEffect=2

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=112,111,110
ColorAmount=0.025000000000000001
ColorEffect=2
ContrastAmount=0.10000000000000001
ContrastEffect=2
Enable=false
IntensityAmount=0
IntensityEffect=0

[Colors:Button]
BackgroundAlternate=$(hex_to_rgb "${c6:-$bg}")
BackgroundNormal=$(hex_to_rgb "$bg")
DecorationFocus=$(hex_to_rgb "$cursor")
DecorationHover=$(hex_to_rgb "$cursor")
ForegroundActive=$(hex_to_rgb "$cursor")
ForegroundInactive=$(hex_to_rgb "${c7:-$fg}")
ForegroundLink=$(hex_to_rgb "${url:-$cursor}")
ForegroundNegative=$(hex_to_rgb "${c1:-$cursor}")
ForegroundNeutral=$(hex_to_rgb "${c3:-$fg}")
ForegroundNormal=$(hex_to_rgb "$fg")
ForegroundPositive=$(hex_to_rgb "${c2:-$cursor}")
ForegroundVisited=$(hex_to_rgb "${c4:-$cursor}")

[Colors:Selection]
BackgroundAlternate=$(hex_to_rgb "${c5:-$cursor}")
BackgroundNormal=$(hex_to_rgb "${sel_bg:-$cursor}")
DecorationFocus=$(hex_to_rgb "$cursor")
DecorationHover=$(hex_to_rgb "$cursor")
ForegroundActive=$(hex_to_rgb "${sel_fg:-$bg}")
ForegroundInactive=$(hex_to_rgb "${sel_fg:-$bg}")
ForegroundLink=$(hex_to_rgb "${url:-$cursor}")
ForegroundNegative=$(hex_to_rgb "${c1:-$cursor}")
ForegroundNeutral=$(hex_to_rgb "${c3:-$fg}")
ForegroundNormal=$(hex_to_rgb "${sel_fg:-$bg}")
ForegroundPositive=$(hex_to_rgb "${c2:-$cursor}")
ForegroundVisited=$(hex_to_rgb "${c4:-$cursor}")

[Colors:Tooltip]
BackgroundAlternate=$(hex_to_rgb "${c6:-$bg}")
BackgroundNormal=$(hex_to_rgb "${c5:-$bg}")
DecorationFocus=$(hex_to_rgb "$cursor")
DecorationHover=$(hex_to_rgb "$cursor")
ForegroundActive=$(hex_to_rgb "$cursor")
ForegroundInactive=$(hex_to_rgb "${c7:-$fg}")
ForegroundLink=$(hex_to_rgb "${url:-$cursor}")
ForegroundNegative=$(hex_to_rgb "${c1:-$cursor}")
ForegroundNeutral=$(hex_to_rgb "${c3:-$fg}")
ForegroundNormal=$(hex_to_rgb "$fg")
ForegroundPositive=$(hex_to_rgb "${c2:-$cursor}")
ForegroundVisited=$(hex_to_rgb "${c4:-$cursor}")

[Colors:View]
BackgroundAlternate=$(hex_to_rgb "${c0:-$bg}")
BackgroundNormal=$(hex_to_rgb "$bg")
DecorationFocus=$(hex_to_rgb "$cursor")
DecorationHover=$(hex_to_rgb "$cursor")
ForegroundActive=$(hex_to_rgb "$cursor")
ForegroundInactive=$(hex_to_rgb "${c7:-$fg}")
ForegroundLink=$(hex_to_rgb "${url:-$cursor}")
ForegroundNegative=$(hex_to_rgb "${c1:-$cursor}")
ForegroundNeutral=$(hex_to_rgb "${c3:-$fg}")
ForegroundNormal=$(hex_to_rgb "$fg")
ForegroundPositive=$(hex_to_rgb "${c2:-$cursor}")
ForegroundVisited=$(hex_to_rgb "${c4:-$cursor}")

[Colors:Window]
BackgroundAlternate=$(hex_to_rgb "${c6:-$bg}")
BackgroundNormal=$(hex_to_rgb "$bg")
DecorationFocus=$(hex_to_rgb "$cursor")
DecorationHover=$(hex_to_rgb "$cursor")
ForegroundActive=$(hex_to_rgb "$cursor")
ForegroundInactive=$(hex_to_rgb "${c7:-$fg}")
ForegroundLink=$(hex_to_rgb "${url:-$cursor}")
ForegroundNegative=$(hex_to_rgb "${c1:-$cursor}")
ForegroundNeutral=$(hex_to_rgb "${c3:-$fg}")
ForegroundNormal=$(hex_to_rgb "$fg")
ForegroundPositive=$(hex_to_rgb "${c2:-$cursor}")
ForegroundVisited=$(hex_to_rgb "${c4:-$cursor}")

[General]
ColorScheme=Matugen
Name=Matugen
shadeSortColumn=true

[KDE]
contrast=4

[WM]
activeBackground=$(hex_to_rgb "$bg")
activeBlend=$(hex_to_rgb "$bg")
activeForeground=$(hex_to_rgb "$fg")
inactiveBackground=$(hex_to_rgb "${c6:-$bg}")
inactiveBlend=$(hex_to_rgb "${c6:-$bg}")
inactiveForeground=$(hex_to_rgb "${c7:-$fg}")
EOF

    mv "$tmp" "$scheme_file"
}

notify_kde_palette_change() {
    if command -v dbus-send >/dev/null 2>&1; then
        dbus-send --session --type=signal \
            /KGlobalSettings \
            org.kde.KGlobalSettings.notifyChange \
            int32:0 int32:0 >/dev/null 2>&1 || true
    fi
}

generate_kde_scheme
notify_kde_palette_change

if pgrep -x mako >/dev/null 2>&1; then
    makoctl reload >/dev/null 2>&1 || pkill -HUP mako >/dev/null 2>&1 || true
fi

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
    QSBIN="$(command -v qs || command -v quickshell || true)"
    if [ -n "$QSBIN" ]; then
        nohup "$QSBIN" >/dev/null 2>&1 &
    fi
fi
