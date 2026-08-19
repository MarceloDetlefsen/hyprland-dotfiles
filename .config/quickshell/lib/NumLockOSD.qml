import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../lib" as Lib

PanelWindow {
    id: root

    required property var theme
    required property var screen

    WlrLayershell.layer:         WlrLayer.Overlay
    WlrLayershell.namespace:     "numlock-osd"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors.bottom: true
    anchors.left:   true
    anchors.right:  true

    exclusiveZone:  0
    implicitHeight: 180
    color:          "transparent"
    visible:        false

    property string labelText: "Num Lock"
    property string sublabel:  ""
    property color  accentColor: root.theme.accentSlider
    property bool   active: false
    property bool   osdVisible: false
    property bool   _ready: false

    FileView {
        id: watcher
        path:         Quickshell.env("HOME") + "/.cache/quickshell/numlock"
        watchChanges: true
        preload:      true
        onFileChanged: reload()
        onLoaded:      root._ready = true
        onTextChanged: root._handleState(text())
    }

    function _show() {
        root.osdVisible = true
        hideTimer.restart()
    }

    function _handleState(raw) {
        if (!root._ready) return
        var v = raw.trim().toLowerCase()
        if (v !== "on" && v !== "off") return

        if (v === "on") {
            root.active = false
            root.sublabel = "Disabled"
            root.accentColor = root.theme.accentRed
        } else {
            root.active = true
            root.sublabel = "Enabled"
            root.accentColor = root.theme.accentSlider
        }
        iconPop.restart()
        _show()
    }

    Timer {
        id: hideTimer
        interval: 2600
        onTriggered: root.osdVisible = false
    }

    Timer {
        id: windowHideTimer
        interval: 240
        onTriggered: root.visible = false
    }

    onOsdVisibleChanged: {
        if (osdVisible) {
            root.visible = true
            windowHideTimer.stop()
        } else {
            windowHideTimer.restart()
        }
    }

    Item {
        anchors.fill: parent

        Item {
            id: card
            width:  290
            height: 90
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:           parent.bottom
            anchors.bottomMargin:     52

            opacity: root.osdVisible ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation {
                    duration:    root.osdVisible ? 140 : 230
                    easing.type: root.osdVisible ? Easing.OutQuad : Easing.InCubic
                }
            }

            transform: Translate {
                y: root.osdVisible ? 0 : 20
                Behavior on y {
                    NumberAnimation {
                        duration:    root.osdVisible ? 200 : 260
                        easing.type: root.osdVisible ? Easing.OutCubic : Easing.InCubic
                    }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width:  parent.width  + 2
                height: parent.height + 2
                radius: root.theme.radiusOuter + 2
                color:  "transparent"
                border.width: 8
                border.color: Qt.rgba(0, 0, 0, root.theme.isDarkMode ? 0.30 : 0.13)
                opacity: 0.55
            }

            Rectangle {
                anchors.fill: parent
                radius:       root.theme.radiusOuter
                color:        root.theme.bgCard
                border.width: 1
                border.color: root.theme.outline

                Rectangle {
                    anchors { fill: parent; margins: 1 }
                    radius: root.theme.radiusOuter - 1
                    color:  Qt.rgba(
                        root.accentColor.r,
                        root.accentColor.g,
                        root.accentColor.b,
                        root.theme.isDarkMode ? 0.08 : 0.05
                    )
                    Behavior on color { ColorAnimation { duration: 300 } }
                }
            }

            RowLayout {
                anchors {
                    fill:         parent
                    leftMargin:   20
                    rightMargin:  20
                }
                spacing: 16

                Item {
                    implicitWidth:  64
                    implicitHeight: 64
                    Layout.alignment: Qt.AlignVCenter

                    Rectangle {
                        anchors.centerIn: parent
                        width:  54
                        height: 54
                        radius: 27
                        color:  Qt.rgba(
                            root.accentColor.r,
                            root.accentColor.g,
                            root.accentColor.b,
                            root.theme.isDarkMode ? 0.15 : 0.10
                        )
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }

                    Item {
                        id: modeIcon
                        anchors.centerIn: parent
                        width:            40
                        height:           40
                        opacity:          root.osdVisible ? 1.0 : 0.0
                        scale:            root.active ? 1.0 : 0.96
                        Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

                        SequentialAnimation on scale {
                            id: iconPop
                            running: false
                            NumberAnimation { from: 0.82; to: 1.08; duration: 90; easing.type: Easing.OutQuad }
                            NumberAnimation { from: 1.08; to: 1.0; duration: 180; easing.type: Easing.OutElastic }
                        }

                        Canvas {
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()

                                var active = root.active
                                var main = active ? root.accentColor : root.theme.textSecondary
                                var soft = active
                                    ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.36)
                                    : Qt.rgba(root.theme.textSecondary.r, root.theme.textSecondary.g, root.theme.textSecondary.b, 0.18)

                                function roundRect(x, y, w, h, r) {
                                    ctx.beginPath()
                                    ctx.moveTo(x + r, y)
                                    ctx.lineTo(x + w - r, y)
                                    ctx.quadraticCurveTo(x + w, y, x + w, y + r)
                                    ctx.lineTo(x + w, y + h - r)
                                    ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h)
                                    ctx.lineTo(x + r, y + h)
                                    ctx.quadraticCurveTo(x, y + h, x, y + h - r)
                                    ctx.lineTo(x, y + r)
                                    ctx.quadraticCurveTo(x, y, x + r, y)
                                    ctx.closePath()
                                }

                                ctx.clearRect(0, 0, width, height)
                                ctx.font = "bold 8px " + root.theme.textFont
                                ctx.textAlign = "center"
                                ctx.textBaseline = "middle"

                                var cell = 9
                                var gap = 3
                                var startX = 4
                                var startY = 4
                                var labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

                                for (var row = 0; row < 3; row++) {
                                    for (var col = 0; col < 3; col++) {
                                        var idx = row * 3 + col
                                        var x = startX + col * (cell + gap)
                                        var y = startY + row * (cell + gap)
                                        ctx.fillStyle = (active && idx === 4) ? main : soft
                                        roundRect(x, y, cell, cell, 2)
                                        ctx.fill()
                                        ctx.fillStyle = active ? main : root.theme.textSecondary
                                        ctx.fillText(labels[idx], x + cell / 2, y + cell / 2 + 0.3)
                                    }
                                }

                                if (!active) {
                                    ctx.strokeStyle = root.theme.accentRed
                                    ctx.lineWidth = 2
                                    ctx.lineCap = "round"
                                    ctx.beginPath()
                                    ctx.moveTo(9, 31)
                                    ctx.lineTo(31, 9)
                                    ctx.stroke()
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 8

                    Text {
                        text:           root.labelText
                        font.family:    root.theme.textFont
                        font.pixelSize: 11
                        font.weight:    Font.Medium
                        color:          root.theme.textSecondary
                        opacity:        0.7
                    }

                    Text {
                        text:           root.sublabel
                        font.family:    root.theme.textFont
                        font.pixelSize: 18
                        font.weight:    Font.Bold
                        color:          root.accentColor
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                }
            }
        }
    }
}
