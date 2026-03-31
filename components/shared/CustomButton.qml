import QtQuick
import Quickshell.Widgets
import qs

Rectangle {
    id: customButton

    required property var iconSource
    property bool isHovered: false

    signal clicked()
    signal hovered(bool hovered)
    signal wheel(WheelEvent event)

    implicitHeight: 30
    implicitWidth: 30
    radius: 5
    color: "transparent"
    scale: mouseArea.containsMouse ? 1.1 : 1

    MouseArea {
        id: mouseArea

        anchors.fill: barButton
        hoverEnabled: true
        onEntered: {
            barButton.isHovered = true;
            barButton.hovered(true);
        }
        onExited: {
        }
        onClicked: barButton.clicked()
        onWheel: (event) => {
            event.accepted = false;
            barButton.wheel(event);
        }
    }

    Image {
        id: icons

        anchors.fill: parent
        anchors.margins: 2
        anchors.centerIn: parent
        cache: true
        fillMode: Image.PreserveAspectCrop
        source: customButton.iconSource
    }

    Behavior on scale {
        NumberAnimation {
            duration: 150
        }

    }

}
