#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_HOME="${SOURCE_HOME:-$HOME}"
DRY_RUN="${DRY_RUN:-0}"
export HOME_PATH="$SOURCE_HOME"

log() {
  printf '%s\n' "$*"
}

run() {
  if [ "$DRY_RUN" = "1" ]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

copy_tree() {
  local src="$1"
  local dst="$2"

  if [ -d "$src" ]; then
    run mkdir -p "$dst"
    run rsync -a "$src/" "$dst/"
  fi
}

copy_file() {
  local src="$1"
  local dst="$2"

  if [ -f "$src" ]; then
    run mkdir -p "$(dirname "$dst")"
    run cp "$src" "$dst"
  fi
}

rewrite_home_paths() {
  local file

  while IFS= read -r -d '' file; do
    if ! grep -Iq . "$file"; then
      continue
    fi

    case "$file" in
      *.png|*.jpg|*.jpeg|*.svg|*.ico|*.gif|*.webp)
        continue
        ;;
    esac

    if [ "$DRY_RUN" = "1" ]; then
      printf '[dry-run] normalize %s\n' "$file"
    else
      perl -0pi -e 's/\Q$ENV{HOME_PATH}\E/\~/g' "$file"
    fi
  done < <(
    find "$REPO_ROOT" \
      \( \
        -path "$REPO_ROOT/.git" -o \
        -path "$REPO_ROOT/.git/*" -o \
        -path "$REPO_ROOT/wallpapers/*" \
      \) -prune -o \
      -type f -print0
  )

  while IFS= read -r -d '' file; do
    if ! grep -Iq . "$file"; then
      continue
    fi

    if [ "$DRY_RUN" = "1" ]; then
      printf '[dry-run] normalize portable paths %s\n' "$file"
      continue
    fi

    perl -0pi -e 's#~\/\.local\/share\/surface-dots-second\/home\/Pictures\/Wallpapers#~/wallpapers#g; s#~\/\.local\/share\/surface-dots-second\/home\/\.config\/rofi\/profile\.jpg#~/.config/rofi/profile.jpg#g; s#~\/\.local\/share\/surface-dots-second\/home\/\.config\/rofi\/icons\/light#~/.config/rofi/icons/light#g; s#~\/Imágenes\/Personal\/Cloud\.png#~/.config/quickshell/profile.jpg#g' "$file"
  done < <(
    find "$REPO_ROOT/dot_config/quickshell" "$REPO_ROOT/dot_config/rofi" \
      -type f -print0
  )
}

log "Sincronizando configs desde: $SOURCE_HOME"

copy_tree "$SOURCE_HOME/.config/hypr" "$REPO_ROOT/dot_config/hypr"
copy_tree "$SOURCE_HOME/.config/waybar" "$REPO_ROOT/dot_config/waybar"
copy_tree "$SOURCE_HOME/.config/wofi" "$REPO_ROOT/dot_config/wofi"
copy_tree "$SOURCE_HOME/.config/kitty" "$REPO_ROOT/dot_config/kitty"
copy_tree "$SOURCE_HOME/.config/gtk-3.0" "$REPO_ROOT/dot_config/gtk-3.0"
copy_tree "$SOURCE_HOME/.config/gtk-4.0" "$REPO_ROOT/dot_config/gtk-4.0"
copy_tree "$SOURCE_HOME/.config/Kvantum" "$REPO_ROOT/dot_config/Kvantum"
copy_tree "$SOURCE_HOME/.config/qt6ct" "$REPO_ROOT/dot_config/qt6ct"
copy_tree "$SOURCE_HOME/.config/qt5ct" "$REPO_ROOT/dot_config/qt5ct"
if [ -d "$SOURCE_HOME/.config/quickshell" ]; then
  run mkdir -p "$REPO_ROOT/dot_config/quickshell"
  run rsync -a --exclude '.cache/' "$SOURCE_HOME/.config/quickshell/" "$REPO_ROOT/dot_config/quickshell/"
fi
copy_tree "$SOURCE_HOME/.config/rofi" "$REPO_ROOT/dot_config/rofi"
copy_tree "$SOURCE_HOME/.config/cava" "$REPO_ROOT/dot_config/cava"
copy_tree "$SOURCE_HOME/.config/mako" "$REPO_ROOT/dot_config/mako"
copy_tree "$SOURCE_HOME/.config/nwg-drawer" "$REPO_ROOT/dot_config/nwg-drawer"
copy_file "$SOURCE_HOME/.zen/installs.ini" "$REPO_ROOT/dot_zen/installs.ini"
copy_file "$SOURCE_HOME/.zen/profiles.ini" "$REPO_ROOT/dot_zen/profiles.ini"
copy_tree "$SOURCE_HOME/wallpapers" "$REPO_ROOT/wallpapers"

copy_file "$SOURCE_HOME/.zshrc" "$REPO_ROOT/dot_zshrc"
copy_file "$SOURCE_HOME/.zprofile" "$REPO_ROOT/dot_zprofile"
copy_file "$SOURCE_HOME/.p10k.zsh" "$REPO_ROOT/dot_p10k.zsh"

rewrite_home_paths

run chmod +x "$REPO_ROOT/install.sh"
run chmod +x "$REPO_ROOT/export-from-host.sh"
run chmod +x "$REPO_ROOT/dot_config/hypr/scripts/"*.sh
run chmod +x "$REPO_ROOT/dot_config/waybar/scripts/"*.sh

log "Exportación lista."
log "Revisá con: git status --short"
