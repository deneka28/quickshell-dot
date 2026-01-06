import QtQuick
import Quickshell.Io

Item {
    id: root

    property int memUsage: 0
    property real usedKb: 0.0
    property real freeKd: 0.0

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if(!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var t = parseFloat(parts[1]) || 1 
                var u = parseFloat(parts[2]) || 0 
                var used = parseInt(parts[2]) || 0
                root.memUsage = Math.round(100 * used / total)
                root.usedKb = (u / 1024) / 1024
                root.freeKd = t - u
            }
        }
        Component.onCompleted: running = true
    }
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            memProc.running = true
        }
    }
}
