#!/usr/bin/env bash

set -euo pipefail

pick_menu() {
  if command -v wofi >/dev/null 2>&1; then
    wofi --dmenu --prompt 'Window layout' --width 320 --height 200
  elif command -v rofi >/dev/null 2>&1; then
    rofi -dmenu -i -p 'Window layout'
  else
    return 127
  fi
}

get_current_layout() {
  hyprctl eval 'local ws = hl.get_active_special_workspace() or hl.get_active_workspace(); if ws then print(ws.tiled_layout) end' 2>/dev/null |
    tr -d '\r' |
    tail -n 1
}

apply_layout() {
  local layout="$1"
  local lua

  case "$layout" in
    dwindle)
      lua='local ws = hl.get_active_special_workspace() or hl.get_active_workspace(); if not ws then return end; local selector = ws.special and tostring(ws.name) or tostring(ws.id); hl.workspace_rule({ workspace = selector, layout = "dwindle" })'
      ;;
    master)
      lua='local ws = hl.get_active_special_workspace() or hl.get_active_workspace(); if not ws then return end; local selector = ws.special and tostring(ws.name) or tostring(ws.id); hl.workspace_rule({ workspace = selector, layout = "master", layout_opts = { orientation = "left" } })'
      ;;
    scrolling)
      lua='local ws = hl.get_active_special_workspace() or hl.get_active_workspace(); if not ws then return end; local selector = ws.special and tostring(ws.name) or tostring(ws.id); hl.workspace_rule({ workspace = selector, layout = "scrolling", layout_opts = { direction = "right" } })'
      ;;
    *)
      return 1
      ;;
  esac

  hyprctl eval "$lua" >/dev/null
}

current_layout="$(get_current_layout)"
current_layout="${current_layout,,}"

layouts=("dwindle" "master" "scrolling")
declare -A labels=(
  [dwindle]="Dwindle"
  [master]="Master"
  [scrolling]="Scrolling"
)

options=()
for layout in "${layouts[@]}"; do
  label="${labels[$layout]}"
  if [[ "$current_layout" == "$layout" ]]; then
    label="$label (actual)"
  fi
  options+=("$label")
done

selection="$(
  printf '%s\n' "${options[@]}" | pick_menu
)" || exit 0

layout=""
case "$selection" in
  Dwindle*) layout="dwindle" ;;
  Master*) layout="master" ;;
  Scrolling*) layout="scrolling" ;;
  *) exit 0 ;;
esac

if apply_layout "$layout"; then
  notify-send "Hyprland" "Window layout: ${labels[$layout]}"
else
  notify-send -u critical "Hyprland" "No pude cambiar el layout."
  exit 1
fi
