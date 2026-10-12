#!/usr/bin/env bash
# ==============================================================================
# pip-overlay.sh - Gestor del escritorio sobrepuesto (Picture-in-Picture)
# Permite ver partidos / videos flotantes mientras trabajas en cualquier workspace.
# ==============================================================================

set -euo pipefail

ACTION="${1:-toggle}"

case "$ACTION" in
    toggle)
        # Alterna la visibilidad del escritorio especial sobrepuesto con animación horizontal
        hyprctl dispatch 'hl.dsp.workspace.toggle_special("overlay")' >/dev/null 2>&1
        ;;
    send)
        # Envía la ventana activa a special:overlay configurándola como PiP,
        # o la devuelve al escritorio normal actual si ya está en el overlay.
        hyprctl eval '
            local win = hl.get_active_window()
            if not win then return end

            local active_ws = hl.get_active_workspace()
            local active_special = hl.get_active_special_workspace()
            local ws_name = (win.workspace and win.workspace.name) or ""
            local is_in_overlay = (ws_name == "special:overlay") or (active_special and active_special.name == "special:overlay" and ws_name:find("special"))

            if is_in_overlay then
                local target_id = (active_ws and active_ws.id) or 1
                hl.dispatch(hl.dsp.window.move({ workspace = target_id }))
                hl.exec_cmd("notify-send -t 2000 -a Hyprland -i video-display \"PiP Overlay\" \"Ventana devuelta al Workspace " .. tostring(target_id) .. "\"")
            else
                if not win.floating then
                    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
                end

                local pip_w = 640
                local pip_h = 360
                local mon = hl.get_active_monitor()
                local mon_w = (mon and mon.width) or 1920
                local mon_h = (mon and mon.height) or 1080
                local pos_x = mon_w - pip_w - 24
                local pos_y = mon_h - pip_h - 24

                hl.dispatch(hl.dsp.window.resize({ x = pip_w, y = pip_h, relative = false }))
                hl.dispatch(hl.dsp.window.move({ x = pos_x, y = pos_y, relative = false }))
                hl.dispatch(hl.dsp.window.move({ workspace = "special:overlay" }))

                if not active_special or active_special.name ~= "special:overlay" then
                    hl.dispatch(hl.dsp.workspace.toggle_special("overlay"))
                end

                hl.exec_cmd("notify-send -t 2500 -a Hyprland -i video-display \"PiP Overlay Activo\" \"⚽ Ventana en modo sobreposición\\n• Super + 0: Ocultar / Mostrar\\n• Super + Shift + 0: Devolver a este escritorio\"")
            end
        ' >/dev/null 2>&1
        ;;
    *)
        echo "Uso: $0 [toggle|send]"
        exit 1
        ;;
esac
