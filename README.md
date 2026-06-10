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
└── .p10k.zsh               # Tema Powerlevel10k
```

## Restaurar en un PC nuevo

### Requisitos previos

- Arch Linux / Manjaro con Hyprland instalado
- Git y Git LFS instalados
- Zsh + Oh My Zsh + Powerlevel10k instalados

### Pasos

```bash
# 1. Clonar el repo (con LFS para los wallpapers)
git clone https://github.com/MarceloDetlefsen/hyprland-dotfiles.git
cd hyprland-dotfiles

# 2. Copiar las configs
cp -r .config/* ~/.config/

# 3. Copiar los wallpapers
cp -r wallpapers ~/

# 4. Copiar Zen Browser
mkdir -p ~/.zen
cp .zen/installs.ini .zen/profiles.ini ~/.zen/

# 5. Copiar los dotfiles de Zsh
cp .zshrc .zprofile .p10k.zsh ~/

# 6. Dar permisos de ejecución a los scripts
chmod +x ~/.config/hypr/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.sh

# 7. Reiniciar Hyprland
hyprctl reload
```

> Si los wallpapers no se descargan, asegurate de tener Git LFS instalado: `sudo pacman -S git-lfs && git lfs install`
>
> Zen Browser guarda su perfil en `~/.zen`, no en `~/.config/zen`.
>
> No conviene versionar carpetas completas de perfil en `.zen/`. Para dotfiles, dejá solo archivos estables como `profiles.ini`, `installs.ini` y otros ajustes puntuales que copies archivo por archivo. Evitá `logins.json`, `session*`, `weave/`, `profile-backup-passwords/` y cualquier carpeta `Default Profile` o `Default (release)`.

## Actualizar el repo

Cuando hagas cambios en tus configs y quieras guardarlos:

```bash
cd ~/hyprland-dotfiles

# Sobreescribir todo con lo que tenés actualmente
rm -rf .config/hypr && cp -r ~/.config/hypr .config/
rm -rf .config/waybar && cp -r ~/.config/waybar .config/
rm -rf .config/wofi && cp -r ~/.config/wofi .config/
rm -rf .config/kitty && cp -r ~/.config/kitty .config/
rm -rf .config/gtk-3.0 && cp -r ~/.config/gtk-3.0 .config/
rm -rf .config/gtk-4.0 && cp -r ~/.config/gtk-4.0 .config/
rm -rf .config/Kvantum && cp -r ~/.config/Kvantum .config/
rm -rf .config/qt6ct && cp -r ~/.config/qt6ct .config/
cp ~/.zen/installs.ini .zen/
cp ~/.zen/profiles.ini .zen/
rm -rf wallpapers && cp -r ~/wallpapers .
cp ~/.zshrc .zprofile .p10k.zsh .

# Commitear y subir
git add .
git commit -m "Update: descripción de lo que cambiaste"
git push
```

## 👨‍💻 Autor

Marcelo Detlefsen