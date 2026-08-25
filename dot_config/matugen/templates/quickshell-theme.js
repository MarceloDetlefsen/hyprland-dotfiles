.pragma library

var bgMain  = "{{ colors.background.default.hex }}"
var bgPanel = "{{ colors.surface_container_highest.default.rgba | set_alpha: 0.88 }}"
var bgCard  = "{{ colors.surface_container.default.hex }}"
var bgItem  = "{{ colors.surface_container_low.default.hex }}"
var bgItemHover = "{{ colors.surface_container_high.default.hex }}"

var fgMain  = "{{ colors.on_surface.default.hex }}"
var fgMuted = "{{ colors.on_surface_variant.default.hex }}"
var fgOnAccent = "{{ colors.on_primary.default.hex }}"

var accent = "{{ colors.primary.default.hex }}"
var accentBlue = "{{ colors.secondary.default.hex }}"
var accentRed  = "{{ colors.error.default.hex }}"
var accentSlider = "{{ colors.tertiary.default.hex }}"
var accentSlider2 = "{{ colors.primary_container.default.hex }}"

var border = "{{ colors.outline.default.rgba | set_alpha: 0.80 }}"
var outline = "{{ colors.outline.default.rgba | set_alpha: 0.20 }}"
var subtleFill = "{{ colors.on_surface.default.rgba | set_alpha: 0.05 }}"
var subtleFillHover = "{{ colors.on_surface.default.rgba | set_alpha: 0.15 }}"
var hoverSpotlight = "{{ colors.on_surface.default.rgba | set_alpha: 0.14 }}"

var weatherd = "{{ colors.on_surface_variant.default.hex }}"
var weatherl = "{{ colors.surface_variant.default.hex }}"
var weatherColor = weatherd

// Sizing
var radiusOuter = 24
var radiusInner = 16

var padCard = 12
var gapCard = 10

var btnH = 54
var sliderH = 24

// Fonts
var textFont = 'Manrope'
var iconFont = 'JetBrainsMono Nerd Font'
