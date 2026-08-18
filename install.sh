#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.local/share/hyprland-dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
DRY_RUN="${DRY_RUN:-0}"

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

backup_if_needed() {
  local target="$1"
  local backup_target="$BACKUP_ROOT/$target"

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$DRY_RUN" = "1" ]; then
      printf '[dry-run] backup %s -> %s\n' "$target" "$backup_target"
    else
      mkdir -p "$(dirname "$backup_target")"
      mv "$target" "$backup_target"
    fi
  fi
}

link_path() {
  local source="$REPO_ROOT/$1"
  local target="$HOME/$2"

  backup_if_needed "$target"
  run mkdir -p "$(dirname "$target")"
  run ln -sfn "$source" "$target"
}

install_pacman_packages() {
  if ! command -v pacman >/dev/null 2>&1; then
    log "pacman no está disponible. Instalá las dependencias manualmente."
    return 0
  fi

  base_packages=(
    base-devel
    git
    git-lfs
    zsh
    hyprland
    hypridle
    hyprlock
    hyprpaper
    waybar
    wofi
    kitty
    mako
    swayidle
    cliphist
    wl-clipboard
    brightnessctl
    playerctl
    pavucontrol
    pipewire
    wireplumber
    networkmanager
    network-manager-applet
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    polkit-gnome
    kvantum
    qt6ct
    gtk3
    gtk4
    numlockx
    cava
    acpi
    upower
    power-profiles-daemon
    dolphin
  )

  run sudo pacman -S --needed --noconfirm "${base_packages[@]}"
}

install_aur_package() {
  local package="$1"
  local build_root="$BACKUP_ROOT/aur-build/$package"

  if command -v paru >/dev/null 2>&1; then
    run paru -S --needed --noconfirm "$package"
    return 0
  fi

  if command -v yay >/dev/null 2>&1; then
    run yay -S --needed --noconfirm "$package"
    return 0
  fi

  run mkdir -p "$build_root"
  if [ "$DRY_RUN" = "1" ]; then
    printf '[dry-run] git clone https://aur.archlinux.org/%s.git %s\n' "$package" "$build_root"
    printf '[dry-run] (cd %s && makepkg -si --noconfirm)\n' "$build_root"
    return 0
  fi

  rm -rf "$build_root"
  git clone "https://aur.archlinux.org/$package.git" "$build_root"
  (
    cd "$build_root"
    makepkg -si --noconfirm
  )
}

install_pacman_packages

if command -v git-lfs >/dev/null 2>&1; then
  run git lfs install --local
  run git lfs pull
fi

for package in hyprshot hyprpicker nwg-drawer musicpresence zen-browser; do
  install_aur_package "$package"
done

link_path ".config/hypr" ".config/hypr"
link_path ".config/waybar" ".config/waybar"
link_path ".config/wofi" ".config/wofi"
link_path ".config/kitty" ".config/kitty"
link_path ".config/gtk-3.0" ".config/gtk-3.0"
link_path ".config/gtk-4.0" ".config/gtk-4.0"
link_path ".config/Kvantum" ".config/Kvantum"
link_path ".config/qt6ct" ".config/qt6ct"
link_path ".zen/installs.ini" ".zen/installs.ini"
link_path ".zen/profiles.ini" ".zen/profiles.ini"
link_path ".zshrc" ".zshrc"
link_path ".zprofile" ".zprofile"
link_path ".p10k.zsh" ".p10k.zsh"
link_path "wallpapers" "wallpapers"

run chmod +x "$HOME/.config/hypr/scripts/"*.sh
run chmod +x "$HOME/.config/waybar/scripts/"*.sh

log "Instalación completa."
log "Recargá Hyprland con: hyprctl reload"
