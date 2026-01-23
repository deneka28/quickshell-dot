import Quickshell.Widgets
import QtQuick

import qs

Rectangle {
    id: styleButton

    required property var iconSource
    property bool isHovered: false
    required property var iconSize
    signal clicked
    signal hovered(bool hovered)
    signal wheel(event: WheelEvent)

    implicitHeight: styleButton.iconSize
    implicitWidth: styleButton.iconSize
    radius: 5

    color: "transparent"

    scale: mouseArea.containsMouse ? 1.2 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: 150
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: styleButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            styleButton.isHovered = true;
            styleButton.hovered(true);
        }
        onExited: {}
        onClicked: styleButton.clicked()

        onWheel: event => {
            event.accepted = false;
            styleButton.wheel(event);
        }
    }

    IconImage {
        id: icons
        anchors.fill: parent
        anchors.margins: 3
        anchors.verticalCenter: parent.verticalCenter
        source: styleButton.iconSource
    }
}
