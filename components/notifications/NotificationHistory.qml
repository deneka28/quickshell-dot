import "../services"
import "../shared"
import "../widgets"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "root:/"

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Заголовок с кнопкой очистки
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "История уведомлений"
                    font.pixelSize: 18
                    font.bold: true
                    color: Config.colors.fontcolor
                    Layout.fillWidth: true
                }

                StylButton {
                    text: "Очистить всё"
                    visible: NotifServer.history.length > 0
                    onClicked: NotifServer.clearHistory()
                    implicitHeight: 20
                    // implicitWidth: 80
                    color: Config.colors.controlscolor
                    fontColor: Config.colors.fontcolor
                    fontPixelSize: 12
                    radius: 4
                }

            }

            // Сообщение если пусто
            Text {
                visible: NotifServer.history.length === 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "История уведомлений пуста"
                color: Config.colors.fontcolor
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            // Список уведомлений
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: NotifServer.history.length > 0
                clip: true

                ListView {
                    id: historyList

                    spacing: 10
                    model: NotifServer.history.slice().reverse()

                    delegate: Rectangle {
                        width: historyList.width
                        // Динамическая высота в зависимости от наличия кнопок
                        height: contentColumn.implicitHeight + 20 + (actionsRow.visible ? actionsRow.height + 10 : 0)
                        color: mouseArea.containsMouse ? Config.colors.widgetcolormidle : Config.colors.widgetcolor
                        radius: 8

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 10

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 10

                                // Иконка приложения
                                ClippingRectangle {
                                    Layout.preferredWidth: 40
                                    Layout.preferredHeight: 40
                                    radius: 15
                                    clip: true
                                    color: modelData.image === "" ? "grey" : "transparent"

                                    Image {
                                        anchors.fill: parent
                                        source: modelData.image || modelData.appIcon
                                        fillMode: Image.PreserveAspectCrop
                                        smooth: true
                                    }

                                }

                                // Содержимое
                                ColumnLayout {
                                    id: contentColumn

                                    Layout.fillWidth: true
                                    spacing: 5

                                    RowLayout {
                                        Layout.fillWidth: true

                                        Text {
                                            text: modelData.summary
                                            font.bold: true
                                            font.pixelSize: 14
                                            color: Config.colors.fontcolor
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: modelData.timeStr
                                            font.pixelSize: 10
                                            color: Config.colors.fontcolor
                                            opacity: 0.6
                                        }

                                    }

                                    Text {
                                        text: modelData.body
                                        font.pixelSize: 12
                                        color: Config.colors.fontcolor
                                        opacity: 0.8
                                        wrapMode: Text.Wrap
                                        Layout.fillWidth: true
                                        maximumLineCount: 3
                                        elide: Text.ElideRight
                                    }

                                }

                                // Кнопка удаления
                                StyledButton {
                                    Layout.preferredWidth: 30
                                    Layout.preferredHeight: 30
                                    iconSize: 16
                                    iconSource: Quickshell.iconPath("edit-delete")
                                    onClicked: NotifServer.removeFromHistory(modelData)
                                }

                            }

                            // Кнопки действий (если есть)
                            RowLayout {
                                id: actionsRow

                                Layout.fillWidth: true
                                spacing: 10
                                visible: modelData.actions && modelData.actions.length > 0

                                Repeater {
                                    model: modelData.actions || []
                                    anchors.margins: 10

                                    StylButton {
                                        // Можно также удалить уведомление после действия
                                        // NotifServer.removeFromHistory(parent.parent.modelData)

                                        text: modelData.text
                                        implicitHeight: 20
                                        fontPixelSize: 12
                                        fontColor: Config.colors.fontcolor
                                        color: Config.colors.controlscolor
                                        radius: 4
                                        onClicked: {
                                            console.log("Action clicked:", modelData.text);
                                            modelData.invoke();
                                        }
                                    }

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
