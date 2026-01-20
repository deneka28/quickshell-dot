import QtQuick
import QtQuick.Layouts

import "../io"
import qs

Item {
    id: kbLayout

    implicitHeight: 30
    implicitWidth: 30

    MouseArea {
        id: area

        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            Keyboard.nextLayout();
        }
        onWheel: {
            Keyboard.nextLayout();
        }
    }
    RowLayout {
        id: layout
        spacing: 2
        anchors.fill: parent
        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            color: "transparent"

            Text {
                id: indicator
                anchors.centerIn: parent
                text: Keyboard.layout?.code.toUpperCase()
                color: Config.colors.fontcolor
                font.pixelSize: 16
                font.family: Config.font
            }
        }
    }
}
