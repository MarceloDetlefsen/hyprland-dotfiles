# hyprland-dotfiles 🖥️

Mis configuraciones personales de Hyprland y el ecosistema Wayland. Guardadas acá para no perderlas y poder levantarlas fácil en cualquier PC.

## Contenido

```
.
├── .config/
│   ├── hypr/               # Hyprland — ventanas, keybinds, animaciones
│   │   ├── hyprland.conf
│   │   ├── hyprpaper.conf
│   │   ├── hypridle.conf
│   │   ├── hyprlock.conf
│   │   ├── env.conf
│   │   └── scripts/
│   │       ├── battery-alert.sh
│   │       └── random-wallpaper.sh
│   ├── waybar/             # Barra de estado
│   ├── wofi/               # Launcher
│   ├── kitty/              # Terminal
│   ├── gtk-3.0/            # Temas GTK3
│   ├── gtk-4.0/            # Temas GTK4
│   ├── Kvantum/            # Temas Qt via Kvantum
│   └── qt6ct/              # Configuración Qt6
├── .zen/                   # Zen Browser — solo config estable, no perfiles completos
├── wallpapers/             # Fondos de pantalla (vía Git LFS)
├── .zshrc
├── .zprofile
├── .p10k.zsh               # Prompt local
└── install.sh              # Instalador reproducible
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
- enlaza los dotfiles al `$HOME`
- guarda cualquier archivo previo en `~/.local/share/hyprland-dotfiles-backup/`
- baja los archivos de Git LFS del repo antes de enlazar wallpapers

Para simular la instalación sin tocar nada:

```bash
DRY_RUN=1 bash ./install.sh
```

## Actualizar el repo

Cuando hagas cambios en tus configs y quieras guardarlos:

```bash
cd ~/hyprland-dotfiles

# Commitear y subir
git add .
git commit -m "Update: descripción de lo que cambiaste"
git push
```

## 👨‍💻 Autor

Marcelo Detlefsen
