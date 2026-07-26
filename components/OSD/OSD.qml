pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs

PanelWindow {
    id: root

    // Центр экрана через все якоря false и margins
    anchors {
        top: false
        bottom: false
        left: false
        right: false
    }

    implicitWidth: 260
    implicitHeight: 72
    visible: OsdService.visible
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Config.colors.widgetcolor
        radius: 14
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.08)

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Иконка

            IconImage {
                implicitWidth: 26
                implicitHeight: 26
                Layout.alignment: Qt.AlignVCenter
                source: {
                    switch (OsdService.type) {
                    case OsdService.Type.Volume:
                        if (OsdService.boolValue)
                            return Quickshell.iconPath("audio-volume-muted-symbolic");
                        if (OsdService.value >= 0.66)
                            return Quickshell.iconPath("audio-volume-high-symbolic");
                        if (OsdService.value >= 0.33)
                            return Quickshell.iconPath("audio-volume-medium-symbolic");
                        return Quickshell.iconPath("audio-volume-low-symbolic");
                    case OsdService.Type.Brightness:
                        if (OsdService.value >= 0.66)
                            return Quickshell.iconPath("display-brightness-high-symbolic");
                        if (OsdService.value >= 0.33)
                            return Quickshell.iconPath("display-brightness-medium-symbolic");
                        return Quickshell.iconPath("display-brightness-low-symbolic");
                    case OsdService.Type.Layout:
                        return Quickshell.iconPath("input-keyboard-symbolic");
                    case OsdService.Type.CapsLock:
                        return OsdService.boolValue ? Quickshell.iconPath("capslock-enabled-symbolic") : Quickshell.iconPath("capslock-disabled-symbolic");
                    default:
                        return "";
                    }
                }
            }

            // Контент — прогресс-бар или текст
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                // Лейбл
                Text {
                    text: {
                        switch (OsdService.type) {
                        case OsdService.Type.Volume:
                            return OsdService.boolValue ? "Без звука" : "Громкость";
                        case OsdService.Type.Brightness:
                            return "Яркость";
                        case OsdService.Type.Layout:
                            return "Раскладка";
                        case OsdService.Type.CapsLock:
                            return OsdService.boolValue ? "Caps Lock вкл" : "Caps Lock выкл";
                        default:
                            return "";
                        }
                    }
                    color: Config.colors.fontcolor
                    font.pixelSize: 12
                    font.family: Config.font
                    opacity: 0.6
                }

                // Прогресс-бар для громкости и яркости
                Rectangle {
                    visible: OsdService.type === OsdService.Type.Volume || OsdService.type === OsdService.Type.Brightness
                    Layout.fillWidth: true
                    height: 6
                    radius: 3
                    color: Config.colors.bgcolor

                    Rectangle {
                        width: parent.width * (OsdService.boolValue ? 0 : OsdService.value)
                        height: parent.height
                        radius: 3
                        color: OsdService.type === OsdService.Type.Volume ? "#89b4fa" : "#f9e2af"

                        Behavior on width {
                            NumberAnimation {
                                duration: 80
                            }
                        }
                    }
                }

                // Текст для раскладки и caps
                Text {
                    visible: OsdService.type === OsdService.Type.Layout || OsdService.type === OsdService.Type.CapsLock
                    text: {
                        switch (OsdService.type) {
                        case OsdService.Type.Layout:
                            return OsdService.strValue.toUpperCase();
                        case OsdService.Type.CapsLock:
                            return OsdService.boolValue ? "ON" : "OFF";
                        default:
                            return "";
                        }
                    }
                    color: Config.colors.fontcolor
                    font.pixelSize: 15
                    font.bold: true
                    font.family: Config.font
                }
            }

            // Процент для громкости и яркости
            Text {
                visible: OsdService.type === OsdService.Type.Volume || OsdService.type === OsdService.Type.Brightness
                text: OsdService.boolValue ? "—" : Math.round(OsdService.value * 100) + "%"
                color: Config.colors.fontcolor
                font.pixelSize: 13
                font.family: Config.font
                Layout.minimumWidth: 36
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
