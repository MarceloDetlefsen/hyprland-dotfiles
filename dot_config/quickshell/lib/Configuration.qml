pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root
    readonly property string configPath:
        Qt.resolvedUrl("usersettings.json").toString().replace("file://", "")
    readonly property string palettePath:
        Qt.resolvedUrl("../palette.json").toString().replace("file://", "")

    // Bar / Dock
    // Settings from disk a beat after startup;
    property bool ready: false

    property string barStyle:              "task"
    property bool   barForceWorkspaceMode: false
    property bool   barShowBattery:        true
    property bool   barShowTray:           true
    property int    barHeight:             50
    property int    iconSize:              24

    // Desktop
    property bool   showScreenBorders: true
    property string desktopMode:       "snes"
    property string wallpaperDir:      Quickshell.env("HOME") + "/Pictures/Wallpapers"

    // External tools
    readonly property string nowPlayingBin:
        Qt.resolvedUrl("../bin/now_playing").toString().replace("file://", "")
    readonly property string screenshotScript: Quickshell.env("HOME") + "/.config/hypr/screenshots/captureArea.sh"
    readonly property string evercalBin:       "/opt/evercal/ever_cal"

    // Hub
    property int    maxEvents:       1
    property bool   useCustomColors: false
    property color  customAccent:    "#7AA1A6"
    property color  customBg:        "#141719"

    // Live palette from matugen
    property color  themeBgMain:         "#121318"
    property color  themeBgCard:         "#1f1f25"
    property color  themeBgItem:         "#1b1b21"
    property color  themeBgItemHover:    "#29292f"
    property color  themeFgMain:         "#e4e1e9"
    property color  themeFgMuted:        "#c6c5d0"
    property color  themeFgOnAccent:     "#222c61"
    property color  themeAccent:         "#bac3ff"
    property color  themeAccentBlue:     "#c3c5dd"
    property color  themeAccentRed:      "#ffb4ab"
    property color  themeAccentSlider:   "#e5bad8"
    property color  themeAccentSlider2:  "#394379"
    property color  themeBorder:         "#90909a"
    property color  themeOutline:        "#90909a"
    property color  themeSubtleFill:     "#e4e1e9"
    property color  themeSubtleFillHover: "#e4e1e9"
    property color  themeHoverSpotlight: "#e4e1e9"
    property color  themeWeatherd:       "#c6c5d0"
    property color  themeWeatherl:       "#46464f"
    property color  themeWeatherColor:   "#c6c5d0"

    // Weather
    property string weatherApiKey: ""
    property string weatherLat:    ""
    property string weatherLon:    ""

    // Screen borders
    property int    borderThickness:    7
    property color  borderFrameColor:   "#141719"
    property bool   bordersEnabled:     true
    property bool   bordersForceVisible: false
    property bool   borderUseCustomColor: false

    // Taskbar
    property int    taskbarExclusiveZone:      53
    property bool   taskbarForceDockMode:      false
    property bool   taskbarForceWorkspaceMode: false
    property bool   taskbarCustomBg:           false
    property color  taskbarCustomBgColor:      "#141719"
    property color  taskbarAccent:             "#759b61"

    // Profile
    property string profileImageOverride: ""

    // Shaders
    property string currentShader: "none"

    // Power menu
    // Skin selector shared with utils/PowerMenu.qml.
    property string powerMenuStyle: "life"

    // Per-skin accent colours
    property color powerMenuLifeDark:     "#859866"
    property color powerMenuLifeLight:    "#6c8453"
    property color powerMenuCassiniDark:  "#d57fb069"  // alpha matches the skin's original
    property color powerMenuCassiniLight: "#759b61"

    readonly property string _baseDir:
        Qt.resolvedUrl(".").toString().replace(/^file:\/\//, "").replace(/\/$/, "")
    readonly property string _cacheDir: _baseDir.split("/").slice(0, -1).join("/") + "/.cache"
    readonly property string powerMenuStyleFile:  _cacheDir + "/power_menu_style"
    readonly property string powerMenuColorsFile: _cacheDir + "/power_menu_colors"

    function setPowerMenuStyle(s) {
        if (s !== "life" && s !== "cassini") return
        powerMenuStyle = s
        Quickshell.execDetached(["bash", "-c",
            "mkdir -p \"$(dirname '" + powerMenuStyleFile + "')\"; " +
            "printf '%s' '" + s + "' > '" + powerMenuStyleFile + "'"])
    }

    // Set one accent for (style x theme) and republish the colours cache that
    // utils/PowerMenu.qml reads on launch.
    function setPowerMenuColor(style, dark, hex) {
        if (style === "cassini") { if (dark) powerMenuCassiniDark = hex; else powerMenuCassiniLight = hex }
        else                     { if (dark) powerMenuLifeDark    = hex; else powerMenuLifeLight    = hex }
        save()
        writePowerMenuColors()
    }

    // Restore all power-menu accents to their built-in defaults.
    function resetPowerMenuColors() {
        powerMenuLifeDark     = "#859866"
        powerMenuLifeLight    = "#6c8453"
        powerMenuCassiniDark  = "#d57fb069"
        powerMenuCassiniLight = "#759b61"
        save()
        writePowerMenuColors()
    }

    function writePowerMenuColors() {
        var json = JSON.stringify({
            lifeDark:     String(powerMenuLifeDark),
            lifeLight:    String(powerMenuLifeLight),
            cassiniDark:  String(powerMenuCassiniDark),
            cassiniLight: String(powerMenuCassiniLight)
        })
        Quickshell.execDetached(["bash", "-c",
            "mkdir -p \"$(dirname '" + powerMenuColorsFile + "')\"; " +
            "printf '%s' '" + json + "' > '" + powerMenuColorsFile + "'"])
    }

    FileView {
        id: pmStyleFile
        path: root.powerMenuStyleFile
        preload: true
        onLoaded: {
            var s = String(text() || "").trim().toLowerCase()
            if (s === "cassini" || s === "life") root.powerMenuStyle = s
        }
    }

    // Persistence
    function save() { writeTimer.restart() }

    Timer {
        id: writeTimer
        interval: 60
        onTriggered: root._flush()
    }

    function _flush() {
        configFile.setText(JSON.stringify({
            barStyle:                 root.barStyle,
            barForceWorkspaceMode:    root.barForceWorkspaceMode,
            barShowBattery:           root.barShowBattery,
            barShowTray:              root.barShowTray,
            barHeight:                root.barHeight,
            iconSize:                 root.iconSize,
            showScreenBorders:        root.showScreenBorders,
            desktopMode:              root.desktopMode,
            wallpaperDir:             root.wallpaperDir,
            maxEvents:                root.maxEvents,
            useCustomColors:          root.useCustomColors,
            customAccent:             String(root.customAccent),
            customBg:                 String(root.customBg),
            currentShader:            root.currentShader,
            weatherApiKey:            root.weatherApiKey,
            weatherLat:               root.weatherLat,
            weatherLon:               root.weatherLon,
            borderThickness:          root.borderThickness,
            borderFrameColor:         String(root.borderFrameColor),
            bordersEnabled:           root.bordersEnabled,
            bordersForceVisible:      root.bordersForceVisible,
            borderUseCustomColor:     root.borderUseCustomColor,
            taskbarExclusiveZone:     root.taskbarExclusiveZone,
            taskbarForceDockMode:     root.taskbarForceDockMode,
            taskbarForceWorkspaceMode:root.taskbarForceWorkspaceMode,
            taskbarCustomBg:          root.taskbarCustomBg,
            taskbarCustomBgColor:     String(root.taskbarCustomBgColor),
            taskbarAccent:            String(root.taskbarAccent),
            profileImageOverride:     root.profileImageOverride,
            powerMenuLifeDark:        String(root.powerMenuLifeDark),
            powerMenuLifeLight:       String(root.powerMenuLifeLight),
            powerMenuCassiniDark:     String(root.powerMenuCassiniDark),
            powerMenuCassiniLight:    String(root.powerMenuCassiniLight)
        }))
    }

    function load() {
        try {
            var raw = configFile.text()
            if (!raw || raw.length === 0) return
            var d = JSON.parse(raw)
            if (d.barStyle                 !== undefined) root.barStyle                 = d.barStyle
            if (d.barForceWorkspaceMode    !== undefined) root.barForceWorkspaceMode    = d.barForceWorkspaceMode
            if (d.barShowBattery           !== undefined) root.barShowBattery           = d.barShowBattery
            if (d.barShowTray              !== undefined) root.barShowTray              = d.barShowTray
            if (d.barHeight                !== undefined) root.barHeight                = d.barHeight
            if (d.iconSize                 !== undefined) root.iconSize                 = d.iconSize
            if (d.showScreenBorders        !== undefined) root.showScreenBorders        = d.showScreenBorders
            if (d.desktopMode              !== undefined) root.desktopMode              = d.desktopMode
            if (d.wallpaperDir             !== undefined) root.wallpaperDir             = d.wallpaperDir
            if (d.maxEvents                !== undefined) root.maxEvents                = d.maxEvents
            if (d.useCustomColors          !== undefined) root.useCustomColors          = d.useCustomColors
            if (d.customAccent             !== undefined) root.customAccent             = d.customAccent
            if (d.customBg                 !== undefined) root.customBg                 = d.customBg
            if (d.currentShader            !== undefined) root.currentShader            = d.currentShader
            if (d.weatherApiKey            !== undefined) root.weatherApiKey            = d.weatherApiKey
            if (d.weatherLat               !== undefined) root.weatherLat               = d.weatherLat
            if (d.weatherLon               !== undefined) root.weatherLon               = d.weatherLon
            if (d.borderThickness          !== undefined) root.borderThickness          = d.borderThickness
            if (d.borderFrameColor         !== undefined) root.borderFrameColor         = d.borderFrameColor
            if (d.bordersEnabled           !== undefined) root.bordersEnabled           = d.bordersEnabled
            if (d.bordersForceVisible      !== undefined) root.bordersForceVisible      = d.bordersForceVisible
            if (d.borderUseCustomColor     !== undefined) root.borderUseCustomColor     = d.borderUseCustomColor
            if (d.taskbarExclusiveZone     !== undefined) root.taskbarExclusiveZone     = d.taskbarExclusiveZone
            if (d.taskbarForceDockMode     !== undefined) root.taskbarForceDockMode     = d.taskbarForceDockMode
            if (d.taskbarForceWorkspaceMode!== undefined) root.taskbarForceWorkspaceMode= d.taskbarForceWorkspaceMode
            if (d.taskbarCustomBg          !== undefined) root.taskbarCustomBg          = d.taskbarCustomBg
            if (d.taskbarCustomBgColor     !== undefined) root.taskbarCustomBgColor     = d.taskbarCustomBgColor
            if (d.taskbarAccent            !== undefined) root.taskbarAccent            = d.taskbarAccent
            if (d.profileImageOverride     !== undefined) root.profileImageOverride     = d.profileImageOverride
            if (d.powerMenuLifeDark        !== undefined) root.powerMenuLifeDark        = d.powerMenuLifeDark
            if (d.powerMenuLifeLight       !== undefined) root.powerMenuLifeLight       = d.powerMenuLifeLight
            if (d.powerMenuCassiniDark     !== undefined) root.powerMenuCassiniDark     = d.powerMenuCassiniDark
            if (d.powerMenuCassiniLight    !== undefined) root.powerMenuCassiniLight    = d.powerMenuCassiniLight
        } catch(e) {
            console.warn("[Configuration] load failed:", e)
        }
    }

    FileView {
        id: configFile
        path: root.configPath
        preload: true
        watchChanges: true
        onLoaded: { root.load(); root.ready = true; root.writePowerMenuColors() }
        onTextChanged: root.load()
        onFileChanged: reload()
        onLoadFailed: root.ready = true
    }

    function loadPalette() {
        try {
            var raw = paletteFile.text()
            if (!raw || raw.length === 0) return
            var p = JSON.parse(raw)
            if (p.background         !== undefined) root.themeBgMain        = p.background
            if (p.surface            !== undefined) root.themeBgCard        = p.surface
            if (p.surface_container  !== undefined) root.themeBgItem        = p.surface_container_low || p.surface_container || p.surface
            if (p.surface_container  !== undefined) root.themeBgItemHover   = p.surface_container_high || p.surface_container_highest || p.surface_container
            if (p.on_surface         !== undefined) root.themeFgMain        = p.on_surface
            if (p.on_surface_variant  !== undefined) root.themeFgMuted       = p.on_surface_variant
            if (p.on_primary         !== undefined) root.themeFgOnAccent    = p.on_primary
            if (p.accent             !== undefined) root.themeAccent        = p.accent
            if (p.secondary          !== undefined) root.themeAccentBlue    = p.secondary
            if (p.error               !== undefined) root.themeAccentRed     = p.error
            if (p.tertiary           !== undefined) root.themeAccentSlider  = p.tertiary
            if (p.primary_container   !== undefined) root.themeAccentSlider2 = p.primary_container
            if (p.outline            !== undefined) {
                root.themeOutline = p.outline
                root.themeBorder = Qt.rgba(p.outline.r, p.outline.g, p.outline.b, 0.80)
            }
            if (p.on_surface         !== undefined) {
                root.themeSubtleFill = Qt.rgba(p.on_surface.r, p.on_surface.g, p.on_surface.b, 0.05)
                root.themeSubtleFillHover = Qt.rgba(p.on_surface.r, p.on_surface.g, p.on_surface.b, 0.15)
                root.themeHoverSpotlight = Qt.rgba(p.on_surface.r, p.on_surface.g, p.on_surface.b, 0.14)
            }
            if (p.on_surface_variant !== undefined) root.themeWeatherd      = p.on_surface_variant
            if (p.surface_variant    !== undefined) root.themeWeatherl      = p.surface_variant
            if (p.on_surface_variant !== undefined) root.themeWeatherColor  = p.on_surface_variant
        } catch(e) {
            console.warn("[Configuration] palette load failed:", e)
        }
    }

    FileView {
        id: paletteFile
        path: root.palettePath
        preload: true
        watchChanges: true
        onLoaded: root.loadPalette()
        onTextChanged: root.loadPalette()
        onFileChanged: reload()
        onLoadFailed: root.loadPalette()
    }
}
