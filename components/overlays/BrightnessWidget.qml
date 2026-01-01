import QtQuick
import Quickshell
import Quickshell.Widgets

import "root:/"
import "../shared"
import "../services"
import "../settings"
Scope {
    id: root

    Connections {
        target: Brightness

        function onBrightnessChanged() {
            root.shouldShowOsd = true;
        }
    }
    property bool shouldShowOsd: false
    property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null

    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        CircleBat {
            id: circleBat
            isVisible: GlobalStates.osdNeeded
            size: 90
            colorCircle: Config.colors.fontcolor
            colorBackground: Config.colors.bgcolor
            showBackground: true
            arcBegin: 0
            arcEnd: monitor ? 360 * monitor.brightness : 360 * 0.5
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
    }
}
