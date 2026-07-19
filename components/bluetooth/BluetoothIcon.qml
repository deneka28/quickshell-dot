pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Bluetooth

import "root:/"
import "../shared"

BarWidget {
    id: root
    color: "transparent"
    implicitHeight: 24
    implicitWidth: 24

    HyprlandFocusGrab {
        id: grab
        windows: [bluetoothPanel]
        onCleared: {
            bluetoothPanel.closeWithAnimation();
        }
    }

    BarButton {
        id: powerIcon
        anchors.centerIn: parent
        iconSource: Quickshell.iconPath("bluetooth-symbolic")

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                grab.active = true;
                bluetoothPanel.show();
            }
        }
        scale: area.containsMouse ? 1.1 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }
    }
    BluetoothPanel {
        id: bluetoothPanel
        visible: false
    }
}
