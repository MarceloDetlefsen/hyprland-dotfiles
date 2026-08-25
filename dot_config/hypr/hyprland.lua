local var_mod = "SUPER"

-- =========================

-- HYPRLAND NVIDIA CONFIG

-- =========================
require("env")

local function read_border_colors()
    local path = os.getenv("HOME") .. "/.config/hypr/generated/colors.conf"
    local active = "rgba(8d9199ff)"
    local inactive = "rgba(8d9199aa)"
    local f = io.open(path, "r")
    if not f then
        return active, inactive
    end
    for line in f:lines() do
        local a = line:match("col%.active_border%s*=%s*(rgba%([^)]+%))")
        if a then active = a end
        local i = line:match("col%.inactive_border%s*=%s*(rgba%([^)]+%))")
        if i then inactive = i end
    end
    f:close()
    return active, inactive
end

-- plugin = /var/cache/hyprpm/chelo/hyprland-plugins/hyprexpo.so
hl.monitor({
    output = "",
    disabled = false,
    mode = "preferred",
    position = "auto",
    scale = 1,
})
hl.monitor({
    output = "eDP-1",
    disabled = false,
    mode = "1920x1080@144",
    position = "0x0",
    scale = 1,
})
hl.monitor({
    output = "HDMI-A-1",
    disabled = false,
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
    mirror = "eDP-1",
})

-- ---------- ENV ---------------

-- env = KDE_SESSION_VERSION,6

-- env = QT_QPA_PLATFORMTHEME,kde

-- env = XDG_MENU_PREFIX,plasma-

-- --------- AUTOSTART ---------

-- INPUT / HARDWARE
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/numlockcontrol.sh sync")
end)

-- SYSTEM SERVICES
hl.on("hyprland.start", function()
    hl.exec_cmd("polkit-kde-agent")
    hl.exec_cmd("nm-applet")
end)

-- exec-once = ~/.config/hypr/scripts/ensure-deep-sleep.sh
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/watch-suspend-events.sh")
end)

-- PORTALS (CRÍTICO - ORDEN IMPORTA)
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-gtk")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal")
end)

-- CLIPBOARD
hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

-- UI / BARS / NOTIFICATIONS
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/bin/qs")
    hl.exec_cmd("/usr/bin/mako")
end)

-- HYPRLAND ECOSYSTEM
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swayidle -w before-sleep '~/.config/hypr/scripts/lock-session.sh' timeout 600 '~/.config/hypr/scripts/lock-session.sh' timeout 900 '~/.config/hypr/scripts/suspend-deep.sh'")
end)

-- CUSTOM
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/battery-alert.sh")
end)

-- OPTIONAL / PERSONAL
hl.on("hyprland.start", function()
    hl.exec_cmd("musicpresence")
end)

-- ABRIR GPARTED
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)

-- ---------- INPUT ----------
hl.config({
    input = {
        kb_layout = "latam",
        numlock_by_default = true,
        follow_mouse = 1,
        mouse_refocus = false,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            clickfinger_behavior = true,
        },
    },
})

-- ---------- MOUSE (Logitech G203) ----------
hl.device({
    name = "logitech-g203-lightsync-gaming-mouse",
    left_handed = true,
})
hl.device({
    name = "logitech-g203-lightsync-gaming-mouse-keyboard-1",
    left_handed = true,
})

-- ATRÁS (botón 275)

-- bind = , mouse:275, exec, ydotool key 125:1 105:1 105:0 125:0

-- ADELANTE (botón 276)

-- bind = , mouse:276, exec, ydotool key 125:1 106:1 106:0 125:0

-- ---------- GENERAL ----------
local active_border, inactive_border = read_border_colors()
hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 3,
        border_size = 2,
        col = {
            active_border = active_border,
            inactive_border = inactive_border,
        },
        layout = "dwindle",
    },
})

-- ------- QUITAR FONDO OG ------
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        animate_manual_resizes = true,
        enable_swallow = true,
        swallow_regex = "\"^(kitty)$\"",
    },
})

-- ---------- DWINDLE LAYOUT ----------
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- ---------- DECORATION ----------
hl.config({
    decoration = {
        rounding = 7,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        dim_inactive = false,
        dim_strength = 0.19,
        dim_around = 0.6,
        shadow = {
            enabled = true,
            range = 3,
            render_power = 17,
            color = "rgba(44220044)",
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 2,
            new_optimizations = true,
        },
    },
})

-- ---------- ANIMATIONS ----------
hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("smooth", { type = "bezier", points = { {0.25, 0.1}, {0.25, 1.0} } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 3,
    bezier = "smooth",
    style = "popin 85%",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 3,
    bezier = "smooth",
    style = "popin 85%",
})
hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 3,
    bezier = "smooth",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 2,
    bezier = "smooth",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 3,
    bezier = "smooth",
    style = "slidefade 15%",
})

-- ---------- VOLUME CONTROLS ----------

-- Subir volumen
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/audiocontrol.sh i"))

-- Bajar volumen
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/audiocontrol.sh d"))

-- Mute / Unmute
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/audiocontrol.sh m"))
hl.bind("ALT + F5", hl.dsp.exec_cmd("~/.config/hypr/scripts/audiocontrol.sh m"))

-- non-consuming so Hyprland still toggles the real Num Lock state
hl.bind("code:77", hl.dsp.exec_cmd("~/.config/hypr/scripts/numlockcontrol.sh toggle"), {
    non_consuming = true,
})

-- ---------- BRIGHTNESS CONTROLS ----------

-- Subir brillo
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightnesscontrol.sh i"))

-- Bajar brillo
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightnesscontrol.sh d"))

-- ---------- SCREENSHOTS (ImpPnt) ----------
hl.bind(var_mod .. " + P", hl.dsp.exec_cmd("hyprshot -m output -c"))
hl.bind(var_mod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprshot -m region -c"))
hl.bind(var_mod .. " + CTRL + P", hl.dsp.exec_cmd("hyprshot -m output -o ~/Imágenes"))

-- ---------- CLIPHIST -----------
hl.bind(var_mod .. " + V", hl.dsp.exec_cmd("sh -c \"cliphist list | wofi --dmenu | cliphist decode | wl-copy\""))

-- ---------- CAVA ----------
hl.on("hyprland.start", function()
    hl.exec_cmd("cava &")
    hl.exec_cmd("sleep 1 && hyprctl dispatch togglefloating class:^(cava)$")
    hl.exec_cmd("sleep 1 && hyprctl dispatch resizewindowpixel exact 600 200,class:^(cava)$")
    hl.exec_cmd("sleep 1 && hyprctl dispatch movewindowpixel exact 660 20,class:^(cava)$")
    hl.exec_cmd("sleep 1 && hyprctl dispatch setopacity 0.8,class:^(cava)$")
    hl.exec_cmd("sleep 1 && hyprctl dispatch border none,class:^(cava)$")
end)

-- ---------- BINDS BÁSICOS ----------
hl.bind(var_mod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(var_mod .. " + D", hl.dsp.exec_cmd("wofi --show drun --allow-images --no-actions  --width 600 --height 400"))
hl.bind(var_mod .. " + N", hl.dsp.exec_cmd("nwg-drawer"))
hl.bind(var_mod .. " + S", hl.dsp.global("quickshell:shaderDrawer"))
hl.bind(var_mod .. " + Q", hl.dsp.window.close())
hl.bind(var_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(var_mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(var_mod .. " + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/random-wallpaper.sh"))
hl.bind(var_mod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind("ALT + F4", hl.dsp.exec_cmd("hyprctl layers | grep -q power-menu || quickshell -p ~/.config/quickshell/utils/PowerMenu.qml"))
hl.bind(var_mod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(var_mod .. " + Z", hl.dsp.exec_cmd("gtk-launch zen"))
hl.bind(var_mod .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(var_mod .. " + SHIFT + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/audio-output.sh"))
hl.bind(var_mod .. " + SHIFT + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(var_mod .. " + O", hl.dsp.exec_cmd("~/.config/hypr/scripts/hdmi-mode.sh"))

-- ---------- WORKSPACES ----------
hl.bind(var_mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(var_mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(var_mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(var_mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(var_mod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(var_mod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(var_mod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(var_mod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(var_mod .. " + 9", hl.dsp.focus({ workspace = 9 }))

-- Crear / ir al siguiente workspace disponible
hl.bind("SUPER + equal", hl.dsp.focus({ workspace = "+1" }))

-- Borrar workspace actual (solo si está vacío)
hl.bind("SUPER + minus", hl.dsp.focus({ workspace = "empty" }))
hl.bind(var_mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(var_mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(var_mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(var_mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(var_mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(var_mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(var_mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(var_mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(var_mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))

-- ---------- MOVER FOCO (VIM STYLE) ----------
hl.bind(var_mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(var_mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(var_mod .. " + J", hl.dsp.focus({ direction = "up" }))
hl.bind(var_mod .. " + K", hl.dsp.focus({ direction = "down" }))

-- ---------- MOVER VENTANAS ----------
hl.bind(var_mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(var_mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(var_mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "up" }))
hl.bind(var_mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "down" }))

-- ---------- RESIZE VENTANA ACTIVA ----------
hl.bind(var_mod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }))
hl.bind(var_mod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }))
hl.bind(var_mod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }))
hl.bind(var_mod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }))

-- ------ MOVER CON MOUSE -------
hl.bind(var_mod .. " + mouse:272", hl.dsp.window.drag(), {
    mouse = true,
})
hl.bind(var_mod .. " + mouse:273", hl.dsp.window.resize(), {
    mouse = true,
})

-- ------ Windows Tab LIke ------

-- bind = $mod, TAB, hyprexpo:expo

-- =========================

-- MOVER LIBRE (SIN TILING)

-- =========================

-- Toggle flotante para mover sin que Hyprland razone layout
hl.bind(var_mod .. " + SHIFT + M", hl.dsp.window.float({ action = "toggle" }))

-- ---------- WINDOW RULES (RICE) ----------

-- windowrulev2 = float, class:^(kitty)$

-- windowrulev2 = size 950 550, class:^(kitty)$

-- windowrulev2 = center, class:^(kitty)$

-- windowrulev2 = rounding 8, class:^(kitty)$

-- windowrulev2 = opacity 0.9 0.9, class:^(kitty)$

-- windowrulev2 = float, class:^(org.pwmt.zathura)$

-- windowrulev2 = size 750 1000, class:^(org.pwmt.zathura)$

-- windowrulev2 = float, class:^(blueman-manager)$

-- windowrulev2 = size 500 300, class:^(blueman-manager)$

-- windowrulev2 = move 1165 777, class:^(blueman-manager)$

-- windowrulev2 = rounding 10, class:^(blueman-manager)$

-- windowrulev2 = opacity 0.90 0.90, class:^(blueman-manager)$

-- windowrulev2 = bordercolor rgb(87b158) rgb(2D353B), class:^(blueman-manager)$

-- windowrulev2 = animation popin, class:^(blueman-manager)$

-- windowrulev2 = dimaround, class:^(blueman-manager)$

-- windowrulev2 = float, class:^(nm-connection-editor)$

-- windowrulev2 = size 500 600, class:^(nm-connection-editor)$

-- windowrulev2 = center, class:^(nm-connection-editor)$

-- windowrulev2 = rounding 10, class:^(nm-connection-editor)$

-- windowrulev2 = opacity 0.95 0.95, class:^(nm-connection-editor)$

-- windowrulev2 = bordercolor rgb(87b158), class:^(nm-connection-editor)$

-- windowrulev2 = float, class:^(lens)$

-- windowrulev2 = center, class:^(lens)$

-- windowrulev2 = size 1000 700, class:^(lens)$

-- windowrulev2 = rounding 10, class:^(lens)$

-- windowrulev2 = bordercolor rgb(374527), class:^(lens)$

-- windowrulev2 = float, class:^(xdg-desktop-portal-gtk)$

-- windowrulev2 = center, class:^(xdg-desktop-portal-gtk)$

-- windowrulev2 = size 700 400, class:^(xdg-desktop-portal-gtk)$

-- windowrulev2 = float, title:^(Open File)(.*)$

-- windowrulev2 = center, title:^(Open File)(.*)$

-- windowrulev2 = size 900 600, title:^(Open File)(.*)$

-- windowrulev2 = dimaround, title:^(Open File)(.*)$

-- windowrulev2 = float, title:^(Save As)(.*)$

-- windowrulev2 = center, title:^(Save As)(.*)$

-- windowrulev2 = size 900 600, title:^(Save As)(.*)$

-- windowrulev2 = dimaround, title:^(Save As)(.*)$

-- windowrulev2 = float, title:^(File Upload)(.*)$

-- windowrulev2 = center, title:^(File Upload)(.*)$

-- windowrulev2 = size 900 600, title:^(File Upload)(.*)$

-- windowrulev2 = float, title:^(Confirm to replace files)$

-- windowrulev2 = center, title:^(Confirm to replace files)$

-- windowrulev2 = size 500 300, title:^(Confirm to replace files)$

-- windowrulev2 = dimaround, title:^(Confirm to replace files)$

-- windowrulev2 = float, title:^(File Operation Progress)(.*)$

-- windowrulev2 = center, title:^(File Operation Progress)(.*)$

-- windowrulev2 = size 500 300, title:^(File Operation Progress)(.*)$

-- HyprMod managed settings
require("hyprland-gui")
