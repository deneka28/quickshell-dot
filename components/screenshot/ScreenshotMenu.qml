import "../shared"
import "../widgets"
import QtQuick
import Quickshell
import Quickshell.Io
import "root:/"

SlidingPopup {
    // Process'ы

    id: screenshotPopup

    property bool open: false

    direction: "down"
    implicitWidth: 220
    implicitHeight: contentColumn.implicitHeight + 20
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

        Process {
            id: screenshotArea

            running: false
            // Запускаем через hyprctl dispatch для правильного окружения
            command: ["hyprctl", "dispatch", "exec", "sh -c 'grim -g \"$(slurp)\" - | wl-copy'"]
            onExited: (code, status) => {
                console.log("Screenshot area exited:", code);
            }
        }

        Process {
            id: screenshotWindow

            running: false
            command: ["/home/alex/.config/quickshell/components/scripts/screenshot-window.sh"]
            onStarted: {
                console.log("Screenshot window process started");
            }
            onExited: (code, status) => {
                console.log("Screenshot window exited:", code, "status:", status);
            }
        }

        Process {
            id: screenshotFull

            running: false
            command: ["sh", "-c", "grim - | wl-copy"]
            onExited: (code, status) => {
                console.log("Screenshot full exited:", code);
            }
        }

        Process {
            id: screenshotAreaSave

            running: false
            command: ["hyprctl", "dispatch", "exec", "sh -c 'grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png'"]
            onExited: (code, status) => {
                console.log("Save area exited:", code);
            }
        }

        Process {
            id: screenshotFullSave

            running: false
            command: ["sh", "-c", "grim ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"]
            onExited: (code, status) => {
                console.log("Save full exited:", code);
            }
        }

        // Таймеры для задержки запуска
        Timer {
            id: windowSaveTimer

            interval: 300
            onTriggered: {
                console.log("Starting area screenshot...");
                screenshotFullSave.running = true;
            }
        }

        Timer {
            id: windowTimer

            interval: 300
            onTriggered: {
                console.log("Starting window screenshot...");
                screenshotWindow.running = true;
            }
        }

        Timer {
            id: areaSaveTimer

            interval: 200
            onTriggered: {
                console.log("Starting save area screenshot...");
                screenshotAreaSave.running = true;
            }
        }

        Column {
            id: contentColumn

            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Text {
                width: parent.width
                text: "Скриншот"
                font.pixelSize: 16
                font.bold: true
                color: Config.colors.fontcolor
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#0cc0f2"
            }

            StylButton {
                width: parent.width
                text: "📐 Выбрать область"
                onClicked: {
                    screenshotPopup.closeWithAnimation();
                    screenshotArea.running = true;
                }
            }

            StylButton {
                width: parent.width
                text: "🪟 Текущее окно"
                onClicked: {
                    screenshotPopup.closeWithAnimation();
                    windowTimer.start();
                }
            }

            StylButton {
                width: parent.width
                text: "🖥️ Весь экран"
                onClicked: {
                    screenshotFull.running = true;
                    screenshotPopup.closeWithAnimation();
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#0cc0f2"
            }

            StylButton {
                width: parent.width
                text: "💾 Сохранить область"
                onClicked: {
                    screenshotPopup.closeWithAnimation();
                    areaSaveTimer.start();
                }
            }

            StylButton {
                width: parent.width
                text: "💾 Сохранить экран"
                onClicked: {
                    screenshotPopup.closeWithAnimation();
                    windowSaveTimer.start();
                }
            }

        }

    }

}
