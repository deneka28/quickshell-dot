pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland
import "root:/"
import "../shared"
import "../devices"
import "../io"

BarWidget {
    id: root
    color: "transparent"
    implicitHeight: 24
    implicitWidth: 24
    visible: DeviceIo.devices.length > 0

    // Уведомления от DeviceIo
Connections {
    target: DeviceIo
    
    function onMounted(device) {
        let name = DeviceIo.getDeviceName(device)
        NotifServer.notify("💾 Монтирование", name + " успешно смонтирован", 3000)
    }
    
    function onUnmounted(device) {
        let name = DeviceIo.getDeviceName(device)
        NotifServer.notify("🔌 Размонтирование", name + " успешно размонтирован", 3000)
    }
    
    function onMountError(error) {
        NotifServer.notify("⚠️ Ошибка", error, 5000)
    }
}

    HyprlandFocusGrab {
        id: grab
        windows: [deviceMenu]
        onCleared: {
            deviceMenu.closeWithAnimation()
        }
    }

    BarButton {
        id: deviceIcon
        anchors.centerIn: parent
        iconSource: Quickshell.iconPath("drive-removable-media-symbolic")

        Rectangle {
            visible: DeviceIo.devices.some(d => !d.isMounted)
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: -2
            anchors.topMargin: -2
            width: 16
            height: 16
            radius: 8
            color: "#0cc0f2"
            border.width: 1
            border.color: Config.colors.widgetcolor

            Text {
                anchors.centerIn: parent
                text: DeviceIo.devices.filter(d => !d.isMounted).length
                color: "white"
                font.pixelSize: 9
                font.bold: true
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                grab.active = !grab.active
                if (deviceMenu.open) {
                    deviceMenu.closeWithAnimation()
                } else {
                    deviceMenu.show()
                }
            }
        }

        scale: area.containsMouse ? 1.1 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }
    }

    DeviceMenu {
        id: deviceMenu
    }
}
