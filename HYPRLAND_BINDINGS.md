# Bindings de Hyprland

Este documento resume los bindings activos definidos en:
- [`dot_config/hypr/hyprland.lua`](/home/chelo/hyprland-dotfiles/dot_config/hypr/hyprland.lua)
- [`dot_config/hypr/shader.lua`](/home/chelo/hyprland-dotfiles/dot_config/hypr/shader.lua)

Los bindings comentados en la config no se incluyen.

## Audio, brillo y hardware

| Atajo | Accion |
| --- | --- |
| `XF86AudioRaiseVolume` | Sube el volumen con `audiocontrol.sh i`. |
| `XF86AudioLowerVolume` | Baja el volumen con `audiocontrol.sh d`. |
| `XF86AudioMute` | Silencia o reactiva el audio. |
| `Alt + F5` | Silencia o reactiva el audio. |
| `code:77` | Alterna Num Lock sin consumir el evento. |
| `XF86MonBrightnessUp` | Sube el brillo con `brightnesscontrol.sh i`. |
| `XF86MonBrightnessDown` | Baja el brillo con `brightnesscontrol.sh d`. |

## Capturas y utilidades rapidas

| Atajo | Accion |
| --- | --- |
| `Super + P` | Captura la salida actual y la copia. |
| `Super + Shift + P` | Captura una region y la copia. |
| `Super + Ctrl + P` | Captura la salida actual y la guarda en `~/Imágenes`. |
| `Super + M` | Activa o desactiva el magnificador. |
| `Super + T` | Activa o desactiva el cursor de presentacion. |
| `Super + V` | Abre el historial de clipboard, elige un item y lo copia. |
| `Super + Y` | Abre el selector de layout de ventana (`dwindle`, `master`, `scrolling`). |

## Panel Hub

El panel principal de Quickshell se abre y cierra con `Super + Space`. Dentro del panel, las teclas hacen esto:

| Tecla | Accion |
| --- | --- |
| `d` | Cambia a tema oscuro, solo si no estas ya en oscuro. |
| `l` | Cambia a tema claro, solo si no estas ya en claro. |
| `n` | Expande o colapsa las notificaciones. |
| `s` | Abre o cierra el panel de settings. |
| `w` | Abre o cierra el selector de wallpapers. |
| `m` | Abre o cierra el panel de displays. |
| `b` | Abre o cierra la tarjeta de bateria / estado del sistema. |
| `Esc` | Cierra todo el hub. |

Notas:
- `s` y `w` se reemplazan entre si dentro del mismo panel.
- `m` cierra `s` y `w` cuando activa el panel de displays.
- `b` no reemplaza al hub, solo muestra u oculta la tarjeta inferior.

## Aplicaciones y sesion

| Atajo | Accion |
| --- | --- |
| `Super + Return` | Abre `kitty`. |
| `Super + D` | Abre el launcher de aplicaciones `wofi`. |
| `Super + N` | Abre `nwg-drawer`. |
| `Super + S` | Abre el panel de shaders de Quickshell. |
| `Super + G` | Abre el selector de wallpapers de Quickshell. |
| `Super + Q` | Cierra la ventana activa. |
| `Super + F` | Alterna pantalla completa en la ventana activa. |
| `Super + Shift + R` | Recarga Hyprland. |
| `Super + R` | Cambia el wallpaper aleatoriamente. |
| `Super + B` | Abre el menu de energia de Waybar. |
| `Super + Shift + Q` | Cierra la sesion de Hyprland. |
| `Alt + F4` | Abre el power menu de Quickshell si no esta visible. |
| `Super + E` | Abre `dolphin`. |
| `Super + Z` | Abre el navegador `zen`. |
| `Super + C` | Toma un color con `hyprpicker -a`. |
| `Super + Shift + A` | Abre el selector de salida de audio. |
| `Super + Shift + Alt + L` | Bloquea la pantalla con `hyprlock`. |
| `Super + O` | Abre el cambio de modo HDMI. |

## Workspaces

| Atajo | Accion |
| --- | --- |
| `Super + 1` a `Super + 9` | Cambia al workspace 1 al 9. |
| `Super + =` | Cambia al siguiente workspace disponible. |
| `Super + -` | Cambia a un workspace vacio disponible. |
| `Super + Shift + 1` a `Super + Shift + 9` | Mueve la ventana activa al workspace 1 al 9. |

## Foco, movimiento y resize

| Atajo | Accion |
| --- | --- |
| `Super + H` | Mueve el foco a la ventana de la izquierda. |
| `Super + L` | Mueve el foco a la ventana de la derecha. |
| `Super + J` | Mueve el foco a la ventana de arriba. |
| `Super + K` | Mueve el foco a la ventana de abajo. |
| `Super + Shift + H` | Mueve la ventana activa a la izquierda. |
| `Super + Shift + L` | Mueve la ventana activa a la derecha. |
| `Super + Shift + J` | Mueve la ventana activa hacia arriba. |
| `Super + Shift + K` | Mueve la ventana activa hacia abajo. |
| `Super + Shift + Left` | Reduce el ancho de la ventana activa. |
| `Super + Shift + Right` | Aumenta el ancho de la ventana activa. |
| `Super + Shift + Up` | Reduce la altura de la ventana activa. |
| `Super + Shift + Down` | Aumenta la altura de la ventana activa. |
| `Super + Shift + M` | Alterna la ventana activa entre flotante y tiling. |

## Mouse

| Atajo | Accion |
| --- | --- |
| `Super + mouse:272` | Arrastra la ventana con el mouse. |
| `Super + mouse:273` | Redimensiona la ventana con el mouse. |

## Shaders

| Atajo | Accion |
| --- | --- |
| `Super + Ctrl + D` | Activa o desactiva `Reading Mode`. |
| `Super + Ctrl + N` | Activa o desactiva `Night Light`. |
| `Alt + C` | Activa o desactiva `CRT Mode`. |
| `Super + Alt + S` | Apaga todos los shaders activos. |

## Nota

En `hyprland.conf` hay una version equivalente de muchos de estos bindings, pero la fuente principal aqui documentada es la version en Lua y el modulo de shaders.
