import "../shared"
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "root:/"

BarWidget {
    id: root

    property var powerButton: [locButton, logoutButton, hibernateButton, shutdownButton, rebootButton]

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

    SystemButton {
        id: locButton

        command: "hyprlock"
        text: "Lock"
        icon: Quickshell.iconPath("system-lock-screen-symbolic")
    }

    SystemButton {
        id: logoutButton

        command: "pkill -u $USER"
        text: "Logout"
        icon: Quickshell.iconPath("system-log-out-symbolic")
    }

    SystemButton {
        id: hibernateButton

        command: "systemctl hibernate"
        text: "Hibernate"
        icon: Quickshell.iconPath("system-hibernate-symbolic")
    }

    SystemButton {
        id: shutdownButton

        command: "systemctl poweroff"
        text: "Shutdown"
        icon: Quickshell.iconPath("system-shutdown-symbolic")
    }

    SystemButton {
        id: rebootButton

        command: "systemctl reboot"
        text: "Reboot"
        icon: Quickshell.iconPath("system-reboot-symbolic")
    }

    BarButton {
        id: powerIcon

        anchors.centerIn: parent
        iconSource: Quickshell.iconPath("start-here-symbolic")
        scale: area.containsMouse ? 1.2 : 1

        MouseArea {
            id: area

            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                grab.active = true;
                slidingPopup.show();
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 150
            }

        }

    }

    SlidingPopup {
        id: slidingPopup

        property bool open: false

        direction: "down" // left, right, up, down
        implicitWidth: 254
        implicitHeight: 250
        visible: open
        color: "transparent"
        cornerRadius: 5

        anchor {
            item: root
            margins.top: 30
            edges: Edges.Top
            gravity: Edges.Bottom
        }

        contentItem: Rectangle {
            anchors.centerIn: parent
            color: Config.colors.widgetcolor
            implicitHeight: 240 //powerRow.implicitHeight + 30
            implicitWidth: 250 //powerRow.implicitWidth + 16
            radius: 8
            border.width: 1
            border.color: '#0cc0f2'

            Column {
                id: powerRow

                anchors.centerIn: parent
                spacing: 4

                //-------------------------About System button-----------------------------------------
                AboutButton {
                    id: aboutButton
                }

                //-------------------------------------------------------------------------------------
                Repeater {
                    model: root.powerButton

                    Rectangle {
                        id: rectRow

                        width: 240
                        height: 30
                        color: powerMouseArea.containsMouse ? '#b703a8f4' : "transparent"
                        radius: 4

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Text {
                                id: textS

                                anchors.verticalCenter: parent.verticalCenter
                                leftPadding: 6
                                text: modelData.text
                                font.pixelSize: 14
                                font.family: Config.font
                                color: Config.colors.fontcolor
                                opacity: powerMouseArea.containsMouse ? 1 : 0.8

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 150
                                    }

                                }

                            }

                            Item {
                                width: rectRow.width - textS.width - iconButton.width - 6
                                height: 24
                            }

                            BarButton {
                                id: iconButton

                                anchors.verticalCenter: parent.verticalCenter
                                iconSource: modelData.icon
                                width: 24
                                height: 24
                                scale: powerMouseArea.containsMouse ? 1.3 : 1

                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 150
                                    }

                                }

                            }

                        }

                        MouseArea {
                            id: powerMouseArea

                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                modelData.exec();
                                slidingPopup.closeWithAnimation();
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 250
                            }

                        }

                    }

                }

            }

        }

    }

}
