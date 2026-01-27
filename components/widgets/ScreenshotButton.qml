pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland

import "root:/"
import "../shared"
import "../screenshot"

BarWidget {
    id: root
    color: "transparent"
    implicitHeight: 24
    implicitWidth: 24

    property alias focusGrab: grab
    
    HyprlandFocusGrab {
        id: grab
        windows: [screenshotMenu]
        onCleared: {
            screenshotMenu.closeWithAnimation()
        }
    }

    BarButton {
        id: screenshotIcon
        anchors.centerIn: parent
        iconSource: Quickshell.iconPath("camera-photo-symbolic")
        
        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            onClicked: {
                grab.active = !grab.active
                
                if (screenshotMenu.open) {
                    screenshotMenu.closeWithAnimation()
                } else {
                    screenshotMenu.show()
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
    
    ScreenshotMenu {
        id: screenshotMenu
    }
}
