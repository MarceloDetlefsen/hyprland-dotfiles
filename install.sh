#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
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

install_pacman_packages() {
  if ! command -v pacman >/dev/null 2>&1; then
    log "pacman no está disponible. Instalá las dependencias manualmente."
    return 0
  fi

  base_packages=(
    base-devel
    git
    git-lfs
    chezmoi
    zsh
    hyprland
    hypridle
    hyprlock
    hyprpaper
    waybar
    wofi
    rofi
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
    qt5ct
    qt6ct
    gtk3
    gtk4
    numlockx
    quickshell
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
  local build_root="/tmp/hyprland-dotfiles-${package}"

  if command -v paru >/dev/null 2>&1; then
    run paru -S --needed --noconfirm "$package"
    return 0
  fi

  if command -v yay >/dev/null 2>&1; then
    run yay -S --needed --noconfirm "$package"
    return 0
  fi

  run rm -rf "$build_root"
  if [ "$DRY_RUN" = "1" ]; then
    printf '[dry-run] git clone https://aur.archlinux.org/%s.git %s\n' "$package" "$build_root"
    printf '[dry-run] (cd %s && makepkg -si --noconfirm)\n' "$build_root"
    return 0
  fi

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

run chezmoi -S "$REPO_ROOT" -D "$HOME" apply --force

log "Instalación completa."
log "Recargá Hyprland con: hyprctl reload"
