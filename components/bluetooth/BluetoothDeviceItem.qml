import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root

    property var device: null

    property bool isConnected: device?.connected ?? false
    property bool isPaired: device?.paired ?? false
    property string deviceName: device?.name ?? device?.address ?? "Неизвестное устройство"

    height: 52
    radius: 8
    color: isConnected ? "#313244" : (hoverArea.containsMouse ? "#252535" : "transparent")

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 10

        // Иконка типа устройства из системной темы
        IconImage {
            implicitHeight: 40
            implicitWidth: 40
            source: root.device?.icon ? Quickshell.iconPath(root.device.icon) : Quickshell.iconPath("bluetooth")
        }

        // Имя + статус
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.deviceName
                color: root.isConnected ? "#cdd6f4" : "#a6adc8"
                font.pixelSize: 13
                font.bold: root.isConnected
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: {
                    if (root.isConnected)
                        return "Подключено";
                    if (root.isPaired)
                        return "Сопряжено";
                    return "";
                }
                visible: text !== ""
                color: root.isConnected ? "#a6e3a1" : "#6c7086"
                font.pixelSize: 11
            }
        }

        // Кнопка подключить/отключить
        Rectangle {
            width: 28
            height: 28
            radius: 6
            color: connectHover.containsMouse ? "#45475a" : "transparent"

            Text {
                anchors.centerIn: parent
                font.family: "Material Symbols Rounded"
                font.pixelSize: 16
                color: root.isConnected ? "#f38ba8" : "#a6e3a1"
                text: root.isConnected ? "\ue16f" : "\ue157" // link_off / link
            }

            MouseArea {
                id: connectHover
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (root.isConnected)
                        root.device.disconnect();
                    else
                        root.device.connect();
                }
            }
        }
    }

    // Правый клик — меню
    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()
    }

    Menu {
        id: contextMenu

        MenuItem {
            text: root.isConnected ? "Отключиться" : "Подключиться"
            onTriggered: {
                if (root.isConnected)
                    root.device.disconnect();
                else
                    root.device.connect();
            }
        }

        MenuItem {
            text: "Забыть устройство"
            enabled: root.isPaired
            onTriggered: root.device.forget()
        }
    }
}
