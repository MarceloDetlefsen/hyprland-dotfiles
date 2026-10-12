#!/usr/bin/env bash
# ==============================================================================
# keybindings.sh - Menú interactivo y toggle de atajos de teclado con Wofi
# ==============================================================================

set -euo pipefail

PID_FILE="/tmp/wofi-bindings-${UID}.pid"

# 1. Toggle: si ya está abierto, cerrarlo de inmediato
if [[ -f "$PID_FILE" ]]; then
    PID="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [[ -n "$PID" ]] && kill -0 "$PID" 2>/dev/null; then
        kill "$PID" 2>/dev/null || true
        rm -f "$PID_FILE"
        exit 0
    fi
    rm -f "$PID_FILE"
fi

# Respaldo: si quedó alguna instancia huérfana de este mismo menú
if pgrep -f "wofi.*--prompt.*Atajos de Teclado" >/dev/null 2>&1; then
    pkill -f "wofi.*--prompt.*Atajos de Teclado" 2>/dev/null || true
    exit 0
fi

# Cerrar otros menús wofi activos para evitar solapamiento
pkill -x wofi 2>/dev/null || true

# 2. Catálogo completo de atajos de Hyprland
# Formato: CATEGORIA \t ATAJO \t DESCRIPCION \t COMANDO_EJECUTABLE (opcional)
RAW_DATA=(
  "Ayuda	Super + F1  o  Super + /	Mostrar / ocultar este menú de atajos (Toggle)	~/.config/hypr/scripts/keybindings.sh"
  "Apps	Super + Return	Abrir terminal Kitty	kitty"
  "Apps	Super + D	Lanzador de aplicaciones (Wofi)	wofi --show drun --allow-images --no-actions --width 600 --height 400"
  "Apps	Super + N	Menú de aplicaciones desplegable (NWG Drawer)	nwg-drawer"
  "Apps	Super + E	Gestor de archivos Dolphin	dolphin"
  "Apps	Super + Z	Navegador web Zen Browser	gtk-launch zen"
  "Apps	Super + Space	Abrir / cerrar Hub central de Quickshell	hyprctl dispatch global quickshell:hubToggle"
  "Apps	Super + S	Abrir cajón de Shaders de Quickshell	hyprctl dispatch global quickshell:shaderDrawer"
  "Ventana	Super + Q	Cerrar la ventana activa	hyprctl dispatch killactive"
  "Ventana	Super + F	Alternar pantalla completa	hyprctl dispatch fullscreen"
  "Ventana	Super + Shift + M	Alternar ventana flotante / mosaico (tiling)	hyprctl dispatch togglefloating"
  "Ventana	Super + Y	Selector de layout (dwindle / master / scrolling)	~/.config/hypr/scripts/window-layout.sh"
  "Ventana	Super + Arrastrar Izq	Mover ventana flotante con el ratón	"
  "Ventana	Super + Arrastrar Der	Redimensionar ventana con el ratón	"
  "Foco	Super + H	Mover foco a la izquierda (Vim)	hyprctl dispatch movefocus l"
  "Foco	Super + L	Mover foco a la derecha (Vim)	hyprctl dispatch movefocus r"
  "Foco	Super + J	Mover foco hacia arriba (Vim)	hyprctl dispatch movefocus u"
  "Foco	Super + K	Mover foco hacia abajo (Vim)	hyprctl dispatch movefocus d"
  "Mover	Super + Shift + H	Mover ventana activa a la izquierda	hyprctl dispatch movewindow l"
  "Mover	Super + Shift + L	Mover ventana activa a la derecha	hyprctl dispatch movewindow r"
  "Mover	Super + Shift + J	Mover ventana activa hacia arriba	hyprctl dispatch movewindow u"
  "Mover	Super + Shift + K	Mover ventana activa hacia abajo	hyprctl dispatch movewindow d"
  "Resize	Super + Shift + Left	Reducir ancho de ventana (-30px)	hyprctl dispatch resizeactive -30 0"
  "Resize	Super + Shift + Right	Aumentar ancho de ventana (+30px)	hyprctl dispatch resizeactive 30 0"
  "Resize	Super + Shift + Up	Reducir alto de ventana (-30px)	hyprctl dispatch resizeactive 0 -30"
  "Resize	Super + Shift + Down	Aumentar alto de ventana (+30px)	hyprctl dispatch resizeactive 0 30"
  "Workspace	Super + 1..9	Cambiar al Workspace 1 al 9	"
  "Workspace	Super + 0	Alternar escritorio sobrepuesto (PiP / Partidos)	~/.config/hypr/scripts/pip-overlay.sh toggle"
  "Workspace	Super + +	Ir al siguiente workspace disponible (+1)	hyprctl dispatch workspace +1"
  "Workspace	Super + -	Ir a un workspace vacío disponible	hyprctl dispatch workspace empty"
  "Workspace	Super + Shift + 1..9	Mover ventana activa al Workspace 1 al 9	"
  "Workspace	Super + Shift + 0	Enviar / devolver ventana a escritorio sobrepuesto (PiP)	~/.config/hypr/scripts/pip-overlay.sh send"
  "Captura	Super + P	Capturar pantalla completa al portapapeles	hyprshot -m output -c"
  "Captura	Super + Shift + P	Capturar región seleccionada al portapapeles	hyprshot -m region -c"
  "Captura	Super + Ctrl + P	Capturar pantalla completa y guardar en ~/Imágenes	hyprshot -m output -o ~/Imágenes"
  "Utilidad	Super + V	Historial del portapapeles (Cliphist + Wofi)	sh -c 'cliphist list | wofi --dmenu | cliphist decode | wl-copy'"
  "Utilidad	Super + C	Selector de color en pantalla (Hyprpicker)	hyprpicker -a"
  "Utilidad	Super + M	Alternar lupa / zoom de pantalla	~/.config/hypr/scripts/magnifier.sh"
  "Utilidad	Super + T	Alternar cursor de presentación	~/.config/hypr/scripts/presentation-cursor.sh toggle"
  "Hardware	Super + Shift + A	Selector de salida de audio	~/.config/hypr/scripts/audio-output.sh"
  "Hardware	Super + O	Selector de modo monitor HDMI	~/.config/hypr/scripts/hdmi-mode.sh"
  "Hardware	XF86AudioRaiseVolume	Subir volumen (+5%)	~/.config/hypr/scripts/audiocontrol.sh i"
  "Hardware	XF86AudioLowerVolume	Bajar volumen (-5%)	~/.config/hypr/scripts/audiocontrol.sh d"
  "Hardware	XF86AudioMute	Silenciar / reactivar audio (Mute)	~/.config/hypr/scripts/audiocontrol.sh m"
  "Hardware	Alt + F5	Silenciar / reactivar audio (Mute alternativo)	~/.config/hypr/scripts/audiocontrol.sh m"
  "Hardware	Bloq Num (code:77)	Alternar Bloq Num (con sincronización OSD)	~/.config/hypr/scripts/numlockcontrol.sh toggle"
  "Hardware	XF86MonBrightnessUp	Subir brillo de pantalla	~/.config/hypr/scripts/brightnesscontrol.sh i"
  "Hardware	XF86MonBrightnessDown	Bajar brillo de pantalla	~/.config/hypr/scripts/brightnesscontrol.sh d"
  "Shader	Super + Ctrl + D	Modo Lectura (Reading Mode)	"
  "Shader	Super + Ctrl + N	Luz Nocturna (Night Light)	"
  "Shader	Alt + C	Modo CRT retro	"
  "Shader	Super + Alt + S	Apagar todos los shaders activos	"
  "Sesión	Super + Shift + R	Recargar configuración de Hyprland	hyprctl reload"
  "Sesión	Super + R	Cambiar fondo de pantalla aleatorio	~/.config/hypr/scripts/random-wallpaper.sh"
  "Sesión	Super + B	Menú de energía (Waybar)	~/.config/waybar/scripts/power-menu.sh"
  "Sesión	Alt + F4	Menú de apagado (Quickshell PowerMenu)	hyprctl layers | grep -q power-menu || quickshell -p ~/.config/quickshell/utils/PowerMenu.qml"
  "Sesión	Super + Shift + Alt + L	Bloquear pantalla (Hyprlock)	hyprlock"
  "Sesión	Super + Shift + Q	Cerrar sesión de Hyprland (Logout)	hyprctl dispatch exit"
  "Hub Qs	[Hub] d	Cambiar a tema oscuro (dentro del Hub)	"
  "Hub Qs	[Hub] l	Cambiar a tema claro (dentro del Hub)	"
  "Hub Qs	[Hub] n	Expandir / colapsar notificaciones	"
  "Hub Qs	[Hub] s	Abrir / cerrar panel de configuración	"
  "Hub Qs	[Hub] w	Abrir / cerrar selector de fondos	"
  "Hub Qs	[Hub] m	Abrir / cerrar panel de pantallas	"
  "Hub Qs	[Hub] b	Abrir / cerrar panel de batería / estado	"
  "Hub Qs	[Hub] Esc	Cerrar el Hub central	"
)

# 3. Formatear para wofi y mapear comandos
declare -A CMD_MAP
IN_FILE="$(mktemp /tmp/wofi-bindings-in-XXXXXX)"
OUT_FILE="$(mktemp /tmp/wofi-bindings-out-XXXXXX)"

cleanup() {
    rm -f "$PID_FILE" "$IN_FILE" "$OUT_FILE"
}
trap cleanup EXIT TERM INT

for row in "${RAW_DATA[@]}"; do
    IFS=$'\t' read -r cat key desc cmd <<< "$row"
    tag="[${cat}]"
    formatted="$(printf '<span alpha="65%%">%-12s</span> <b>%-26s</b>   %s' "$tag" "$key" "$desc")"
    printf '%s\n' "$formatted" >> "$IN_FILE"

    if [[ -n "$cmd" ]]; then
        CMD_MAP["$formatted"]="$cmd"
        stripped="$(printf '%s' "$formatted" | sed -E 's/<[^>]*>//g')"
        CMD_MAP["$stripped"]="$cmd"
    fi
done

# 4. Lanzar wofi en segundo plano guardando su PID directo
wofi --dmenu \
     --prompt "⌨  Atajos de Teclado" \
     --width 820 \
     --height 540 \
     --allow-markup \
     --parse-search \
     --insensitive \
     --no-actions < "$IN_FILE" > "$OUT_FILE" &

WOFI_PID=$!
echo "$WOFI_PID" > "$PID_FILE"

# Esperar a que wofi termine (selección o cierre)
wait "$WOFI_PID" 2>/dev/null || true
rm -f "$PID_FILE"

# 5. Ejecutar la acción si fue seleccionada
if [[ -s "$OUT_FILE" ]]; then
    SELECTION="$(cat "$OUT_FILE")"
    CMD="${CMD_MAP["$SELECTION"]:-}"
    if [[ -z "$CMD" ]]; then
        STRIPPED_SEL="$(printf '%s' "$SELECTION" | sed -E 's/<[^>]*>//g')"
        CMD="${CMD_MAP["$STRIPPED_SEL"]:-}"
    fi

    if [[ -n "$CMD" ]]; then
        eval "$CMD" &
    fi
fi
