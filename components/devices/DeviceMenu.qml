import "../io"
import "../shared"
import "../widgets"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "root:/"

SlidingPopup {
    id: devicePopup

    property bool open: false

    direction: "down"
    implicitWidth: 320
    implicitHeight: Math.min(deviceList.contentHeight + 70, 500)
    visible: open
    color: "transparent"
    cornerRadius: 8

    anchor {
        item: root
        margins.top: 34
        edges: Edges.Top
        gravity: Edges.Bottom
    }

    contentItem: Rectangle {
        anchors.fill: parent
        color: Config.colors.widgetcolor
        radius: 8
        border.width: 1
        border.color: "#0cc0f2"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Заголовок
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Накопители"
                    font.pixelSize: 16
                    font.bold: true
                    color: Config.colors.fontcolor
                    Layout.fillWidth: true
                }

                Text {
                    text: DeviceIo.devices.length + " устр."
                    font.pixelSize: 12
                    color: Config.colors.fontcolor
                    opacity: 0.6
                }

            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#0cc0f2"
            }

            // Пусто
            Text {
                visible: DeviceIo.devices.length === 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Нет подключённых накопителей"
                color: Config.colors.fontcolor
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            // Список устройств
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: DeviceIo.devices.length > 0
                clip: true

                ListView {
                    id: deviceList

                    spacing: 5
                    model: DeviceIo.devices

                    delegate: Rectangle {
                        width: deviceList.width
                        height: contentRow.implicitHeight + 20
                        color: mouseArea.containsMouse ? Config.colors.widgetcolormidle : "transparent"
                        radius: 6

                        RowLayout {
                            id: contentRow

                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 12

                            // Иконка устройства
                            Text {
                                text: modelData.isMounted ? "💾" : "🔌"
                                font.pixelSize: 24
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 32
                                verticalAlignment: Text.AlignVCenter
                            }

                            // Информация
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3

                                // Название и размер
                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        text: modelData.label !== "" ? modelData.label : modelData.name
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: Config.colors.fontcolor
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        // Переводим байты в читаемый формат
                                        text: {
                                            let size = parseInt(modelData.size);
                                            if (size >= 1.07374e+09)
                                                return (size / 1.07374e+09).toFixed(1) + " GB";

                                            if (size >= 1.04858e+06)
                                                return (size / 1.04858e+06).toFixed(1) + " MB";

                                            return (size / 1024).toFixed(1) + " KB";
                                        }
                                        font.pixelSize: 11
                                        color: Config.colors.fontcolor
                                        opacity: 0.6
                                    }

                                }

                                // Информация о файловой системе и точке монтирования
                                Text {
                                    text: {
                                        let info = modelData.fstype;
                                        if (modelData.isMounted)
                                            info += " • " + modelData.mountpoint;

                                        return info;
                                    }
                                    font.pixelSize: 11
                                    color: Config.colors.fontcolor
                                    opacity: 0.7
                                }

                            }

                            // Кнопка монтирования / размонтирования
                            StylButton {
                                Layout.preferredWidth: 90
                                Layout.preferredHeight: 32
                                text: modelData.isMounted ? "Отключить" : "Монтировать"
                                onClicked: {
                                    if (modelData.isMounted)
                                        DeviceIo.umount(modelData.device);
                                    else
                                        DeviceIo.mount(modelData.device);
                                }
                            }

                        }

                        MouseArea {
                            id: mouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            z: -1
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                    }

                }

            }

        }

    }

}
