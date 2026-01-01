import QtQuick
import Quickshell.Hyprland

import qs
import qs.components.shared
import qs.components.workspaces
import qs.components.battery
import qs.components.widgets
import qs.components.services

Rectangle {
    id: root
    color: "transparent"
    width: 150
    height: parent.height
   // border.width: 1

    HyprlandFocusGrab {
        id: grab
        windows: [centralDock]
        onCleared: {
            centralDock.closeWithAnimation()
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            grab.active = true
            centralDock.show()
        }
    }

    property string format: "hh:mm | dd.MM.yyyy"
    Text {
        id: textItem
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
        text: Time.format(root.format)
        font.family: Config.font
        color: Config.colors.fontcolor
        font.pixelSize: 16
    }
    CentralDock {
        id: centralDock
    }
}
