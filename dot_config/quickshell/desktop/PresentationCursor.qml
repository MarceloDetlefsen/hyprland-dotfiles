import QtQuick
import Quickshell
import Quickshell.Wayland
import "../lib" as Lib

PanelWindow {
    id: root

    required property var theme
    required property var screen

    WlrLayershell.layer:         WlrLayer.Overlay
    WlrLayershell.namespace:     "presentation-cursor"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    focusable: visible

    anchors { top: true; bottom: true; left: true; right: true }
    exclusiveZone: 0
    color: "transparent"
    visible: Lib.PresentationCursorState.enabled
    mask: Region {}

    readonly property real ringSize: Math.max(72, Math.min(screen.width, screen.height) * 0.11)
    property real ringX: 0
    property real ringY: 0
    property bool cursorInside: false

    function updateCursor() {
        if (!Lib.PresentationCursorState.cursorValid) {
            root.cursorInside = false
            return
        }

        var gx = Lib.PresentationCursorState.cursorX
        var gy = Lib.PresentationCursorState.cursorY
        var inside = gx >= screen.x && gx < (screen.x + screen.width)
                   && gy >= screen.y && gy < (screen.y + screen.height)
        root.cursorInside = inside
        if (!inside) return

        var cx = gx - screen.x
        var cy = gy - screen.y
        var half = ringSize / 2
        root.ringX = Math.max(0, Math.min(screen.width - ringSize, cx - half))
        root.ringY = Math.max(0, Math.min(screen.height - ringSize, cy - half))
    }

    onVisibleChanged: {
        if (visible) {
            forceActiveFocus()
            updateCursor()
        }
    }

    Connections {
        target: Lib.PresentationCursorState
        function onEnabledChanged() { root.updateCursor() }
        function onCursorXChanged() { root.updateCursor() }
        function onCursorYChanged() { root.updateCursor() }
        function onCursorValidChanged() { root.updateCursor() }
    }

    Item {
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: {
            if (Lib.PresentationCursorState.enabled) {
                Quickshell.execDetached(["bash", "-lc", Quickshell.env("HOME") + "/.config/hypr/scripts/presentation-cursor.sh off"])
            }
        }
    }

    Item {
        id: halo
        x: root.ringX
        y: root.ringY
        width: root.ringSize
        height: root.ringSize
        visible: root.cursorInside && root.visible
        opacity: root.cursorInside && root.visible ? 1.0 : 0.0
        scale: root.cursorInside ? 1.0 : 0.86
        transformOrigin: Item.Center

        Behavior on opacity { NumberAnimation { duration: 70 } }
        Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

        property color accent: root.theme.accent

        Rectangle {
            anchors.centerIn: parent
            width: parent.width + 22
            height: parent.height + 22
            radius: width / 2
            color: "transparent"
            border.width: 2
            border.color: Qt.rgba(halo.accent.r, halo.accent.g, halo.accent.b, 0.30)
        }

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Qt.rgba(halo.accent.r, halo.accent.g, halo.accent.b, 0.02)
            border.width: 4
            border.color: Qt.rgba(halo.accent.r, halo.accent.g, halo.accent.b, 0.95)
        }

        Rectangle {
            anchors.centerIn: parent
            width: 10
            height: 10
            radius: 5
            color: Qt.rgba(1, 1, 1, 0.92)
            border.width: 1
            border.color: Qt.rgba(halo.accent.r, halo.accent.g, halo.accent.b, 0.75)
        }
    }
}
