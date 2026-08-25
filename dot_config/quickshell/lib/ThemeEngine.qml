import QtQuick
import "../theme.js" as Theme

QtObject {
    id: root

    // Follows the shared state by default; assign to pin an instance to one mode
    property bool isDarkMode: ThemeState.isDarkMode
    function toggle() { ThemeState.toggle() }

    // Surfaces
    readonly property color bgMain: Configuration.useCustomColors
        ? Configuration.customBg
        : Theme.bgMain
    readonly property color bgCard:      Theme.bgCard
    readonly property color bgItem:      Theme.bgItem
    readonly property color bgItemHover: Theme.bgItemHover
    readonly property color bgWidget:    Theme.bgCard

    // Text
    readonly property color textPrimary:   Theme.fgMain
    readonly property color textSecondary: Theme.fgMuted
    readonly property color textOnAccent:  Theme.fgOnAccent

    // Accents
    readonly property color accent: Configuration.useCustomColors
        ? Configuration.customAccent
        : Theme.accent
    readonly property color accentBlue: Theme.accentBlue
    readonly property color accentRed:   Theme.accentRed
    readonly property color accentSlider:  Theme.accentSlider
    readonly property color accentSlider2: Theme.accentSlider2

    // Lines and hovers
    readonly property color border:          Theme.border
    readonly property color outline:         Theme.outline
    readonly property color subtleFill:      Theme.subtleFill
    readonly property color subtleFillHover: Theme.subtleFillHover
    readonly property color hoverSpotlight:  Theme.hoverSpotlight

    // Sizing
    readonly property int radiusOuter: Theme.radiusOuter
    readonly property int radiusInner: Theme.radiusInner
    readonly property int padCard:     12
    readonly property int gapCard:     10
    readonly property int btnH:        54
    readonly property int sliderH:     24

    // Used by the top-style calendar card
    readonly property color weatherColor: Theme.weatherColor

    readonly property string textFont: Theme.textFont
    readonly property string iconFont: Theme.iconFont
}
