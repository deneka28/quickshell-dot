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
    property int count: ClipboardIo.clipHistCount
    
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
        // iconSource: ClipboardIo.clipHistCount > 0 
        //         ? Quickshell.iconPath("clipboard-text-outline-symbolic")
        //         : Quickshell.iconPath("clipboard-outline-symbolic")

        iconSource: {
            if (ClipboardIo.clipHistCount === 0) {
                Quickshell.iconPath("clipboard-outline-symbolic")
            } else if (ClipboardIo.clipHistCount !== 0) {
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
                    if (!clipboarPopup.open) {
                        ClipboardIo.refreshList()
                    }
                    grab.active =! grab.active 

                    if (clipboarPopup.open) {
                        clipboarPopup.closeWithAnimation()
                    } else {
                        clipboarPopup.show()
                    }

                } else if (mouse.button === Qt.RightButton) {
                    ClipboardIo.runningWipe = true
                    ClipboardIo.runningCount = true
                }
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
