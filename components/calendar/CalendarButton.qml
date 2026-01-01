import QtQuick
import Quickshell.Widgets


Rectangle {
    id: root

    property real buttonWidth
    property real buttonHeight
    property var iconSource

    signal buttonClicked()

    implicitWidth: buttonWidth
    implicitHeight: buttonHeight

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.buttonClicked()
    }

    IconImage {
        id: icons
        implicitHeight: root.height
        implicitWidth: root.width
        source: root.iconSource
    }

}