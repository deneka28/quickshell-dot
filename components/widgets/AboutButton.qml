import QtQuick
import Quickshell
import Quickshell.Hyprland

import "root:/"
import "../shared"

Rectangle {
    id: rectR
    width: 240
    height: 30
    //border.width: 1
    anchors.horizontalCenter: parent.horizontalCenter

    color: powerM.containsMouse ? '#b703a8f4' : "transparent"
    radius: 4

    Behavior on color {
        ColorAnimation {
            duration: 250
        }
    }
    Row {
        anchors.margins: 8
        Text {
            id: aboutText
            text: "About system"
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 6
            font.pixelSize: 14
            font.family: Config.font
            color: Config.colors.fontcolor
            opacity: powerM.containsMouse ? 1.0 : 0.8

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
        }
        Item {
            width: rectR.width - aboutText.width - aboutButton.width 
            height: 24
        }
        BarButton {
            id: aboutButton
            iconSource: Quickshell.iconPath("start-here-symbolic")

            signal togglePopup(bool visible)

            onHovered: function (hovered) {
                aboutButton.togglePopup(hovered);
            }
            scale: powerM.containsMouse ? 1.1 : 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }
    MouseArea {
        id: powerM
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
            grab.active = true;
            slidingPopup.show();
        }
    }

    HyprlandFocusGrab {
        id: grab
        windows: [slidingPopup]
        onCleared: {
            slidingPopup.closeWithAnimation();
        }
    }
    PopupPanel {
        id: slidingPopup

        direction: "down" // left, right, up, down

        implicitWidth: 400
        implicitHeight: 300
        visible: open
        property bool open: false
        color: "transparent"
        cornerRadius: 5

        contentItem: Rectangle {
            anchors.centerIn: parent
            color: Config.colors.widgetcolor
            implicitHeight: slidingPopup.implicitHeight - 4
            implicitWidth: slidingPopup.implicitWidth - 4
            radius: 8
            border.width: 1
            border.color: '#0cc0f2'
            Rectangle {
                id: header

                implicitWidth: parent.width
                implicitHeight: 40
                // border.width: 1
                color: "transparent"

                Text {
                    id: textHead
                    text: Config.distro
                    font.pixelSize: 18
                    font.family: Config.font
                    color: Config.colors.fontcolor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle {
                id: spaser

                implicitHeight: 1
                implicitWidth: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: header.bottom
                color: Config.colors.fontcolor
            }
            Rectangle {
                id: sysInfo

                implicitWidth: parent.width - 20
                implicitHeight: parent.height - header.height - spaser.height
                color: "transparent"
                //border.width: 1
                anchors.top: spaser.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: compName
                    text: "Computer name: alex-home"
                    font.pixelSize: 12
                    font.family: Config.font
                    color: Config.colors.fontcolor
                    topPadding: 8
                }
                Text {
                    id: userName
                    text: "User name: alex"
                    font.pixelSize: 12
                    font.family: Config.font
                    color: Config.colors.fontcolor
                    topPadding: 4
                    anchors.top: compName.bottom
                }
            }
        }
    }
}
