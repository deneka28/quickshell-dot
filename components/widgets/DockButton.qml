pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland

import "root:/"
import "../shared"

BarWidget {
    id: root
    color: "transparent"
    implicitHeight: 24
    implicitWidth: 24

    HyprlandFocusGrab {
        id: grab
        windows: [slidingPopup]
        onCleared: {
            slidingPopup.closeWithAnimation();
        }
    }

    BarButton {
        id: powerIcon
        anchors.centerIn: parent
        iconSource: Quickshell.iconPath("utilities-tweak-tool-symbolic")

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                grab.active = true;
                slidingPopup.show();
            }
        }
        scale: area.containsMouse ? 1.1 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }
    }

    DockPanel {
        id: slidingPopup
    }
}
