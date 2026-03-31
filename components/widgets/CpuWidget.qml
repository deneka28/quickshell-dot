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
    arcEnd: 280 * (cpuInfo.cpuUsage / 100)
    lineWidth: 4

    IconImage {
        id: icon

        implicitHeight: 36
        implicitWidth: 36
        anchors.centerIn: parent
        source: Quickshell.iconPath("am-cpu-symbolic")
    }

    Text {
        id: brigPercent

        text: cpuInfo.cpuUsage + "%"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        font.family: Config.family
        font.pixelSize: 14
        color: Config.colors.fontcolor
    }

    CpuInfo {
        id: cpuInfo
    }

}
