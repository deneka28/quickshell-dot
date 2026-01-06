import QtQuick
import Quickshell
import Quickshell.Widgets

import "root:/"
import "../shared"
import "../services"

CircleBat {
    id: root
    size: 90
    colorCircle: Config.colors.fontcolor
    colorBackground: Config.colors.bgcolor
    showBackground: true
    arcBegin: 0
    arcEnd: 360 * (cpuInfo.cpuUsage / 100)
    lineWidth: 9
    Rectangle {
        id: separator
        implicitHeight: 2
        implicitWidth: root.size - 30
        anchors.centerIn: parent
    }
    IconImage {
        id: icon
        implicitHeight: 24
        implicitWidth: 24
        anchors.horizontalCenter: parent.horizontalCenter
        source: Quickshell.iconPath("am-cpu-symbolic")
        anchors.bottomMargin: 6
        anchors.bottom: separator.top
    }
    Text {
        id: brigPercent
        text: cpuInfo.cpuUsage + "%"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: 6
        font.family: Config.family
        font.pixelSize: 16
        color: Config.colors.fontcolor
    }
    CpuInfo {
        id: cpuInfo
    }
}

