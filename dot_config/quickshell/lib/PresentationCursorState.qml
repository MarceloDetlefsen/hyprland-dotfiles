pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    readonly property string statePath: Quickshell.env("HOME") + "/.cache/quickshell/presentation_cursor"

    property bool enabled: false
    property real cursorX: 0
    property real cursorY: 0
    property bool cursorValid: false
    property bool _ready: false
    property bool _busy: false

    FileView {
        id: stateWatcher
        path: root.statePath
        watchChanges: true
        preload: true
        onLoaded: {
            root._ready = true
            root._applyState(text())
        }
        onTextChanged: root._applyState(text())
        onFileChanged: reload()
        onLoadFailed: {
            root._ready = true
            root.enabled = false
        }
    }

    function _applyState(raw) {
        if (!root._ready) return
        var v = String(raw || "").trim().toLowerCase()
        root.enabled = (v === "on" || v === "1" || v === "true")
        if (root.enabled) {
            pollTimer.restart()
        } else {
            root.cursorValid = false
            pollTimer.stop()
        }
    }

    property Process cursorProc: Process {
        stdout: StdioCollector {
            onStreamFinished: {
                var text = String(this.text || "").trim()
                var m = text.match(/(-?\d+),\s*(-?\d+)/)
                if (!m) {
                    root.cursorValid = false
                    root._busy = false
                    return
                }
                root.cursorX = parseInt(m[1], 10)
                root.cursorY = parseInt(m[2], 10)
                root.cursorValid = true
                root._busy = false
            }
        }
        onExited: root._busy = false
    }

    property Timer pollTimer: Timer {
        interval: 50
        repeat: true
        running: root.enabled
        triggeredOnStart: true
        onTriggered: root.pollCursor()
    }

    function pollCursor() {
        if (!root.enabled || root._busy) return
        root._busy = true
        cursorProc.command = ["/usr/bin/hyprctl", "cursorpos"]
        cursorProc.running = true
    }
}
