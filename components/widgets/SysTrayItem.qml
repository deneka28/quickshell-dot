//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

MouseArea {
    id: root

    required property SystemTrayItem modelData

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 25
    implicitHeight: 25

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            modelData.activate();
        } else if (modelData.hasMenu) {
            menu.open();
        }
    }

    QsMenuAnchor {
        id: menu
        menu: root.modelData.menu
        anchor{ 
            window: this.QsWindow.window
            rect.x: root.x + QsWindow.window?.width
            rect.y: root.y + 16//+ QsWindow.window?.height
        }
    }

    IconImage {
        id: trayIcon
        width: parent.implicitWidth
        height: parent.implicitHeight
        visible: true
        source: root.modelData.icon
        anchors.verticalCenter: root.verticalCenter
    }
}