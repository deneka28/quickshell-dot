import QtQuick
import Quickshell.Io

Item {
    id: root

    property real storRootUsed
    property real storRootFree
    property real storHomeFree
    property real storHomeUsed
    // property real storagePerc: storageTotal > 0 ? storageUsed / storageTotal : 0
    property string storageDev

    Process {
        id: diskProc
        command: ["sh", "-c", "df -h /"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/)
                if (parts.length >= 3) {
                    root.storRootFree = parseInt(parts[3])
                    root.storRootUsed = parseInt(parts[2])
                }
            }
        }
        Component.onCompleted: running = true
    }
    Process {
        id: diskP
        command: ["sh", "-c", "df -h /home"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/)
                if (parts.length >= 3) {
                    root.storHomeFree = parseInt(parts[3])
                    root.storHomeUsed = parseInt(parts[2])
                }
            }
        }
        Component.onCompleted: running = true
    }
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            diskProc.running = true
            diskP.running = true
        }
    }
}
