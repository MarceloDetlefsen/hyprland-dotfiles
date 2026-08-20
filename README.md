# hyprland-dotfiles 🖥️

Mis configuraciones personales de Hyprland y el ecosistema Wayland. Guardadas acá para no perderlas y poder levantarlas fácil en cualquier PC.

## Contenido

```text
.
├── dot_config/             # Fuente chezmoi para ~/.config
│   ├── hypr/
│   ├── quickshell/
│   ├── rofi/
│   ├── waybar/
│   ├── wofi/
│   ├── cava/
│   ├── kitty/
│   ├── gtk-3.0/
│   ├── gtk-4.0/
│   ├── Kvantum/
│   ├── qt5ct/
│   ├── qt6ct/
│   ├── mako/
│   └── nwg-drawer/
├── dot_zen/                # Zen Browser
├── wallpapers/             # Fondos de pantalla (vía Git LFS)
├── dot_zshrc
├── dot_zprofile
├── dot_p10k.zsh            # Prompt local
├── install.sh              # Bootstrap de paquetes + apply de chezmoi
├── export-from-host.sh     # Exportar configs desde una máquina ya armada
└── .chezmoiignore          # Archivos del repo que no deben aterrizar en $HOME
```

## Restaurar en un PC nuevo

### Requisitos previos

- Arch Linux / Manjaro
- Conexión a internet
- `sudo` habilitado

### Pasos

```bash
git clone https://github.com/MarceloDetlefsen/hyprland-dotfiles.git
cd hyprland-dotfiles
bash ./install.sh
```

El instalador:
- instala dependencias base en Arch/Manjaro
- instala paquetes de AUR si tenés `paru` o `yay`
- ejecuta `chezmoi` contra este repo para aplicar los dotfiles
- baja los archivos de Git LFS del repo antes de aplicar los fondos
- incluye `quickshell`, `rofi`, `cava`, `qt5ct`, `mako` y `nwg-drawer`

Para simular la instalación sin tocar nada:

```bash
DRY_RUN=1 bash ./install.sh
```

## Exportar desde otro host

Si querés reimportar configs desde una máquina ya armada, usá:

```bash
DRY_RUN=1 bash ./export-from-host.sh
```

## 👨‍💻 Autor

Marcelo Detlefsen
