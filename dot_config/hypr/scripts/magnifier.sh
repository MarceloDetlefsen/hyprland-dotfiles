#!/usr/bin/env bash
set -euo pipefail

if [[ ${HYPR_MAGNIFIER_CHILD:-0} == 1 ]]; then
    image="${HYPR_MAGNIFIER_IMAGE:?missing image path}"

    cleanup() {
        printf '\033[?25h'
    }

    trap cleanup EXIT
    printf '\033[?25l'

    kitty +kitten icat --align=center --scale-up --background=black "$image"

    while IFS= read -rsn1 key; do
        if [[ $key == $'\e' ]]; then
            break
        fi
    done

    exit 0
fi

tmpdir="$(mktemp -d)"
cleanup() {
    rm -rf "$tmpdir"
}
trap cleanup EXIT

region="$(slurp)" || exit 0
raw="$tmpdir/capture.png"
zoom="$tmpdir/capture-zoom.png"

grim -g "$region" "$raw"
magick "$raw" -filter point -resize 400% "$zoom"

env \
    HYPR_MAGNIFIER_CHILD=1 \
    HYPR_MAGNIFIER_IMAGE="$zoom" \
    kitty \
        --class HyprMagnifier \
        --title HyprMagnifier \
        --start-as=fullscreen \
        --override confirm_os_window_close=0 \
        --override hide_window_decorations=yes \
        --override window_padding_width=0 \
        "$0"
