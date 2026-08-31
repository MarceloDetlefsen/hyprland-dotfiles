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
        : Configuration.themeBgMain
    readonly property color bgCard:      Configuration.themeBgCard
    readonly property color bgItem:      Configuration.themeBgItem
    readonly property color bgItemHover: Configuration.themeBgItemHover
    readonly property color bgWidget:    Configuration.themeBgCard

    // Text
    readonly property color textPrimary:   Configuration.themeFgMain
    readonly property color textSecondary: Configuration.themeFgMuted
    readonly property color textOnAccent:  Configuration.themeFgOnAccent

    // Accents
    readonly property color accent: Configuration.useCustomColors
        ? Configuration.customAccent
        : Configuration.themeAccent
    readonly property color accentBlue: Configuration.themeAccentBlue
    readonly property color accentRed:   Configuration.themeAccentRed
    readonly property color accentSlider:  Configuration.themeAccentSlider
    readonly property color accentSlider2: Configuration.themeAccentSlider2

    // Lines and hovers
    readonly property color border:          Configuration.themeBorder
    readonly property color outline:         Configuration.themeOutline
    readonly property color subtleFill:      Configuration.themeSubtleFill
    readonly property color subtleFillHover: Configuration.themeSubtleFillHover
    readonly property color hoverSpotlight:  Configuration.themeHoverSpotlight

    // Sizing
    readonly property int radiusOuter: Theme.radiusOuter
    readonly property int radiusInner: Theme.radiusInner
    readonly property int padCard:     12
    readonly property int gapCard:     10
    readonly property int btnH:        54
    readonly property int sliderH:     24

    // Used by the top-style calendar card
    readonly property color weatherColor: Configuration.themeWeatherColor

    readonly property string textFont: Theme.textFont
    readonly property string iconFont: Theme.iconFont
}
