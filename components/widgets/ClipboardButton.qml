pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland

import "root:/"
import "../shared"
import "../io"

BarWidget {
    id: root
    color: "transparent"
    implicitHeight: 24
    implicitWidth: 24
    property int tooltipText: ClipboardIo.clipHistCount
    property list<string> cliphistData: ClipboardIo.clipHistList
    property bool showPopup: false
    property var icon: 0
    HyprlandFocusGrab {
        id: grab
        windows: [clipboarPopup]
        onCleared: {
            clipboarPopup.closeWithAnimation();
        }
    }

    BarButton {
        id: powerIcon
        anchors.centerIn: parent
        // iconSource: Quickshell.iconPath("clipboard-outline-symbolic")
        iconSource: {
            if (root.tooltipText === 0) {
                Quickshell.iconPath("clipboard-outline-symbolic")
            } else if (root.tooltipText !== 0) {
                Quickshell.iconPath("clipboard-text-outline-symbolic")
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent
            property bool isHovered: false
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    if (root.cliphistData.length === 0 || (ClipboardIo.runningList && ClipboardIo.cliphistData !== root.tooltipText)) {
                        ClipboardIo.runningList = true
                        grab.active = true
                        clipboarPopup.show()
                    }
                root.showPopup =! root.showPopup
            } else if (mouse.button === Qt.RightButton) {
                ClipboardIo.runningWipe = true
            }
                // grab.active = true;
                // clipboarPopup.show();
            }
            onEntered: {
                ClipboardIo.runningCount = true
                isHovered = true
            }
            onExited: {
                isHovered = false
            }
        }
        scale: area.containsMouse ? 1.1 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }
    }

    Clipboard {
        id: clipboarPopup
    }
}
