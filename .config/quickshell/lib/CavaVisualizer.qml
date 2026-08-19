import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../theme.js" as Theme

Item {
    id: root

    property bool active: true
    property color color: Theme.accent
    property color mutedColor: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.25)
    property int bars: 16
    property real maxHeight: 18
    property real barWidth: 4
    property real gap: 2
    property var levels: []
    property real phase: 0.0
    property real activity: 0.0

    implicitWidth: Math.max(64, (bars * barWidth) + ((bars - 1) * gap))
    implicitHeight: maxHeight

    readonly property string cavaScript:
        Quickshell.env("HOME") + "/.config/quickshell/bin/qs_cava_visualizer.sh"

    property string _buffer: ""

    function _clamp01(v) {
        return Math.max(0, Math.min(1, Number(v) || 0))
    }

    function _avgLevel() {
        const vals = root.levels || []
        if (vals.length === 0) return 0
        let sum = 0
        for (let i = 0; i < vals.length; i++) {
            sum += Number(vals[i]) || 0
        }
        return sum / vals.length
    }

    function _parseChunk(chunk) {
        _buffer += String(chunk || "")
        const lines = _buffer.split(/\r?\n/)
        _buffer = lines.pop() || ""
        for (const line of lines) {
            const s = String(line || "").trim()
            if (s.length === 0) continue
            const parts = s.split(/[;\s]+/)
            const vals = []
            let peak = 0
            for (let i = 0; i < parts.length && vals.length < root.bars; i++) {
                const n = Number(parts[i])
                if (isFinite(n)) {
                    vals.push(n)
                    if (n > peak) peak = n
                }
            }
            if (vals.length > 0) {
                levels = vals
                activity = peak
            }
        }
    }

    Process {
        id: cavaProc
        running: root.active
        command: [root.cavaScript]

        stdout: SplitParser {
            onRead: (data) => root._parseChunk(data)
        }

        stderr: SplitParser {
            onRead: (data) => {
                const t = String(data || "").trim()
                if (t.length > 0) console.error("cava:", t)
            }
        }

        onExited: {
            if (root.active) restartTimer.restart()
        }
    }

    Timer {
        id: restartTimer
        interval: 1000
        repeat: false
        onTriggered: {
            if (root.active) cavaProc.running = true
        }
    }

    Timer {
        interval: 33
        repeat: true
        running: root.active
        onTriggered: {
            root.phase += 0.16
            if (root.phase > Math.PI * 2) root.phase -= Math.PI * 2
            canvas.requestPaint()
        }
    }

    onActiveChanged: {
        if (!active) {
            cavaProc.running = false
            _buffer = ""
            levels = []
        } else {
            restartTimer.restart()
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Threaded

        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            if (!root.active) return

            const midY = height / 2
            const avg = root._avgLevel() / 100.0
            const amp = Math.max(2.5, (height * 0.34) + (avg * height * 0.22))
            const freq = (Math.PI * 2 * 1.7) / Math.max(1, width)
            const step = Math.max(2, Math.floor(width / Math.max(8, root.bars * 2)))

            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            ctx.save()
            ctx.strokeStyle = Qt.rgba(root.color.r, root.color.g, root.color.b, 0.24)
            ctx.lineWidth = Math.max(4, root.barWidth + 2)
            ctx.beginPath()
            for (let x = 0; x <= width; x += step) {
                const idx = Math.min(root.levels.length - 1, Math.floor((x / Math.max(1, width)) * Math.max(1, root.levels.length)))
                const lvl = root._clamp01((Number(root.levels[idx] ?? 0) || 0) / 60.0)
                const y = midY + Math.sin((x * freq) + root.phase) * amp * (0.28 + lvl)
                if (x === 0) ctx.moveTo(x, y)
                else ctx.lineTo(x, y)
            }
            ctx.stroke()
            ctx.restore()

            ctx.save()
            ctx.strokeStyle = root.color
            ctx.lineWidth = Math.max(1.8, root.barWidth * 0.5)
            ctx.beginPath()
            for (let x = 0; x <= width; x += step) {
                const idx = Math.min(root.levels.length - 1, Math.floor((x / Math.max(1, width)) * Math.max(1, root.levels.length)))
                const lvl = root._clamp01((Number(root.levels[idx] ?? 0) || 0) / 60.0)
                const y = midY + Math.sin((x * freq) + root.phase) * amp * (0.28 + lvl)
                if (x === 0) ctx.moveTo(x, y)
                else ctx.lineTo(x, y)
            }
            ctx.stroke()
            ctx.restore()
        }
    }
}
