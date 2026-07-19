import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell
import QtQuick
import QtQuick.Layouts

import qs
import "../shared"
import "../services"

PopupPanel {
    id: root

    property var adapter: Bluetooth.defaultAdapter
    property var adapterState: adapter?.state ?? BluetoothAdapterState.Disabled
    property bool isEnabled: adapterState === BluetoothAdapterState.Enabled
    property bool isTransitioning: adapterState === BluetoothAdapterState.Enabling || adapterState === BluetoothAdapterState.Disabling
    property bool isBlocked: adapterState === BluetoothAdapterState.Blocked

    // Устройства из Quickshell (сопряжённые)
    // property var knownDevices: adapter?.devices?.values ?? []
    // property var pairedDevices: knownDevices.filter(d => d.paired)

    // Найденные при сканировании
    // property var scannedDevices: []
    // property bool scanning: false

    direction: "down"//"down" // left, right, up, down

    anchors {
        top: true
        left: false
        right: true
    }
    margins {
        top: 4
        right: 4
    }

    implicitWidth: 400
    implicitHeight: 420
    visible: open
    property bool open: false
    color: "transparent"
    cornerRadius: 5

    contentItem: Rectangle {
        anchors.centerIn: parent
        color: Config.colors.widgetcolor
        implicitHeight: root.implicitHeight - 4
        implicitWidth: root.implicitWidth - 4
        radius: 8
        border.width: 1
        border.color: '#0cc0f2'

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 4

            // Заголовок
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Bluetooth"
                    color: "#cdd6f4"
                    font.pixelSize: 15
                    font.bold: true
                }

                Item {
                    Layout.fillWidth: true
                }

                // Кнопка сканирования
                Text {
                    visible: BluetoothService.isEnabled
                    text: BluetoothService.scanning ? "\ue9d0" : "\ue5d5"
                    font.family: "Material Symbols Rounded"
                    font.pixelSize: 18
                    color: BluetoothService.scanning ? "#89b4fa" : "#cdd6f4"
                    rightPadding: 8

                    RotationAnimator on rotation {
                        running: BluetoothService.scanning
                        from: 0
                        to: 360
                        duration: 1000
                        loops: Animation.Infinite
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (BluetoothService.scanning)
                                BluetoothService.stopScan();
                            else
                                BluetoothService.startScan();
                        }
                    }
                }

                // Тоггл вкл/выкл
                Rectangle {
                    width: 36
                    height: 20
                    radius: 10
                    color: BluetoothService.isEnabled ? "#89b4fa" : BluetoothService.isBlocked ? "#f38ba8" : "#313244"

                    opacity: BluetoothService.isTransitioning ? 0.6 : 1.0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    Rectangle {
                        width: 14
                        height: 14
                        radius: 7
                        color: "#1e1e2e"
                        anchors.verticalCenter: parent.verticalCenter
                        x: BluetoothService.isEnabled ? 18 : 4
                        Behavior on x {
                            NumberAnimation {
                                duration: 150
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: !BluetoothService.isTransitioning && !BluetoothService.isBlocked
                        onClicked: BluetoothService.toggleAdapter()
                    }
                }
            }

            // Статус адаптера
            Text {
                text: {
                    switch (BluetoothService.adapterState) {
                    case BluetoothAdapterState.Enabled:
                        return "";
                    case BluetoothAdapterState.Disabled:
                        return "Выключен";
                    case BluetoothAdapterState.Enabling:
                        return "Включается...";
                    case BluetoothAdapterState.Disabling:
                        return "Выключается...";
                    case BluetoothAdapterState.Blocked:
                        return "Заблокирован (rfkill)";
                    default:
                        return "";
                    }
                }
                visible: text !== ""
                color: {
                    switch (BluetoothService.adapterState) {
                    case BluetoothAdapterState.Enabling:
                    case BluetoothAdapterState.Disabling:
                        return "#f9e2af";
                    case BluetoothAdapterState.Blocked:
                        return "#f38ba8";
                    default:
                        return "#6c7086";
                    }
                }
                font.pixelSize: 12
                leftPadding: 4
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#313244"
            }

            ColumnLayout {
                visible: BluetoothService.isEnabled
                Layout.fillWidth: true
                spacing: 4

                // Сопряжённые устройства
                Text {
                    visible: BluetoothService.pairedDevices.length > 0
                    text: "Сопряжённые"
                    color: "#6c7086"
                    font.pixelSize: 11
                    leftPadding: 4
                }

                ListView {
                    id: pairedList
                    Layout.fillWidth: true
                    implicitHeight: contentHeight
                    model: BluetoothService.pairedDevices
                    spacing: 2
                    interactive: false

                    delegate: BluetoothDeviceItem {
                        width: pairedList.width
                        device: modelData
                    }
                }

                // Найденные при сканировании
                Text {
                    visible: BluetoothService.scannedDevices.length > 0
                    text: "Найденные устройства"
                    color: "#6c7086"
                    font.pixelSize: 11
                    leftPadding: 4
                    topPadding: 4
                }

                Repeater {
                    model: BluetoothService.scannedDevices
                    delegate: Rectangle {
                        width: pairedList.width
                        height: 52
                        radius: 8
                        color: scannedHover.containsMouse ? "#252535" : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 10

                            Text {
                                font.family: "Material Symbols Rounded"
                                font.pixelSize: 20
                                color: "#6c7086"
                                text: "\ue1a7"
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: modelData.name
                                    color: "#a6adc8"
                                    font.pixelSize: 13
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: modelData.address
                                    color: "#585b70"
                                    font.pixelSize: 11
                                }
                            }

                            // Кнопка сопряжения
                            Rectangle {
                                width: 28
                                height: 28
                                radius: 6
                                color: pairHover.containsMouse ? "#45475a" : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    font.family: "Material Symbols Rounded"
                                    font.pixelSize: 16
                                    color: "#89b4fa"
                                    text: "\ue157"
                                }

                                MouseArea {
                                    id: pairHover
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: BluetoothService.pairDevice(modelData.address)
                                }
                            }
                        }

                        MouseArea {
                            id: scannedHover
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                        }
                    }
                }

                // Пусто
                Text {
                    visible: BluetoothService.pairedDevices.length === 0 && BluetoothService.scannedDevices.length === 0
                    text: BluetoothService.scanning ? "Сканирование..." : "Нажми кнопку обновления для поиска"
                    color: "#6c7086"
                    font.pixelSize: 13
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    topPadding: 12
                    bottomPadding: 8
                }
            }

            // rfkill подсказка
            Text {
                visible: BluetoothService.isBlocked
                text: "Разблокируй через rfkill unblock bluetooth"
                color: "#6c7086"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                leftPadding: 4
                bottomPadding: 4
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
