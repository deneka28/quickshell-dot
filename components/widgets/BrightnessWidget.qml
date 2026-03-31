import "../services"
import "../shared"
import QtQuick
import Quickshell
import Quickshell.Widgets
import "root:/"

CircleBat {
    id: root

    property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null

    size: 90
    colorCircle: Config.colors.fontcolor
    colorBackground: Config.colors.bgcolor
    showBackground: false
    arcBegin: 0
    arcOffset: 220
    arcEnd: monitor ? 280 * monitor.brightness : 280 * 0.5
    lineWidth: 4

    IconImage {
        id: icon

        implicitHeight: 40
        implicitWidth: 40
        anchors.centerIn: parent
        source: Quickshell.iconPath("display-brightness-symbolic")
    }

    Text {
        id: brigPercent

        text: Math.round(root.monitor.brightness * 100) + "%"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        font.family: Config.family
        font.pixelSize: 14
        color: Config.colors.fontcolor
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        scrollGestureEnabled: true
        onWheel: (event) => {
            event.accepted = true;
            const step = 0.05;
            if (event.angleDelta.y > 0)
                Brightness.increaseBrightness();
            else if (event.angleDelta.y < 0)
                Brightness.decreaseBrightness();
        }
    }

}
