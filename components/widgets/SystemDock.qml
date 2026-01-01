import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "root:/"
import "../shared"

PopupPanel {
    id: systemPopup
    required property var bar
    property int count: 9
    property var powerButton: [locButton, logoutButton, suspendButton, hibernateButton, shutdownButton, rebootButton]
    visible: false
    implicitWidth: 250
    implicitHeight: 300
    // color: Config.colors.widgetcolor
    color: "transparent"

    leftAnchor: true
    rightAnchor: false
    topAnchor: true
    bottomAnchor: false

    leftMarg: 6
    rightMarg: 0
    topMarg: 6

    HyprlandFocusGrab {
        id: grab
        windows: [systemPopup]
        onCleared: {
            systemPopup.visible = false
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            systemPopup.visible = true;
        }
        onExited:
        //systemPopup.visible = false;
        {}//
    }

    SystemButton {
        id: locButton
        command: "loginctl lock-session"
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
        id: suspendButton
        command: "systemctl suspend"
        text: "Suspend"
        icon: Quickshell.iconPath("system-suspend-symbolic")
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

    Column {
        id: powerColumn

        anchors.centerIn: parent
        Repeater {
            model: systemPopup.powerButton

            Rectangle {
                width: 200
                height: 30
                //border.width: 1
                color: "transparent"
                RowLayout {
                    anchors.fill: parent
                    Text {
                        id: textS
                        text: modelData.text
                        font.pixelSize: 18
                        color: Config.colors.fontcolor
                        anchors.verticalCenter: parent.verticalCentert
                    }
                    Item {
                        width: parent.width - textS.width - icons.width - 8
                    }
                    BarButton {
                        id: icons
                        iconSource: modelData.icon
                        Layout.alignment: Qt.AlignCenter
                    }
                }

                MouseArea {
                    id: powerMause
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        modelData.exec();
                    }
                }
            }
        }
    }
}
