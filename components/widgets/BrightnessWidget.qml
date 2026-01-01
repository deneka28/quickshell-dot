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
    arcEnd: monitor ? 360 *  monitor.brightness : 360 * 0.5
    lineWidth: 9

    property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null

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
        source: Quickshell.iconPath("display-brightness-symbolic")
        anchors.bottomMargin: 6
        anchors.bottom: separator.top
    }
    Text {
        id: brigPercent
        text: Math.round(root.monitor.brightness * 100) + "%"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: 6
        font.family: Config.family
        font.pixelSize: 16
        color: Config.colors.fontcolor
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        scrollGestureEnabled: true
        onWheel: event => {
            event.accepted = true;
            const step = 0.05;
            if (event.angleDelta.y > 0) {
                Brightness.increaseBrightness();
            } else if (event.angleDelta.y < 0) {
                Brightness.decreaseBrightness();
            }
        }
    }
}
// Item {
//     id: root

//     Slider {
//         id: slider
//         implicitHeight: 50
//         implicitWidth: 200

//         //property var monitor: Hyprland.focusedMonitor
//         property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null

//         value: monitor ? monitor.brightness : 0.5

//         property real level: slider.value * 100

//         onMoved: if (monitor) {
//             //GlobalStates.osdNeeded = false;
//             monitor.setBrightness(value);
//         }
//     }
// }
