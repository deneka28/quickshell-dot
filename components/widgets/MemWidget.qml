import "../services"
import "../shared"
import QtQuick
import Quickshell
import Quickshell.Widgets
import "root:/"

CircleBat {
    id: root

    size: 90
    colorCircle: Config.colors.fontcolor
    colorBackground: Config.colors.bgcolor
    showBackground: false
    arcBegin: 0
    arcOffset: 220
    arcEnd: 280 * (memInfo.memUsage / 100)
    lineWidth: 4

    IconImage {
        id: icon

        implicitHeight: 36
        implicitWidth: 36
        anchors.centerIn: parent
        source: Quickshell.iconPath("am-memory-symbolic")
    }

    Text {
        id: brigPercent

        text: memInfo.usedKb.toFixed(1) + "GiB"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: Config.family
        font.pixelSize: 14
        color: Config.colors.fontcolor
    }

    MemInfo {
        id: memInfo
    }

}
