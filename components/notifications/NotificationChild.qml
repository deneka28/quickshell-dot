import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import "../widgets"
import qs

Rectangle {
    id: root
    property bool startAnim: false

    property string title: "WawApp"
    property var urgency: Notification.urgency
    property string body: "No content"
    property var rawNotif: null
    property bool tracked: false
    property string image: ""

    property var buttons: [
        {
            label: "Okay!",
            onClick: () => console.log("Okay")
        }
    ]

    opacity: tracked ? 1 : (startAnim ? 1 : 0)
    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutExpo
        }
    }
    Layout.fillWidth: true
    radius: 10

    property bool hovered: mouseHandler.containsMouse
    property bool clicked: mouseHandler.containsPress
    color: hovered ? (clicked ? Config.colors.widgetcolormidle : Config.colors.widgetcolorhard) : Config.colors.widgetcolor
    // color: "red"
    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutExpo
        }
    }
    implicitHeight: Math.max(content.implicitHeight + 30, 80)

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 10

        ClippingRectangle {
            width: 50
            height: 50
            radius: 20
            clip: true
            color: root.image === "" ? "grey" : "transparent"
            Image {
                anchors.fill: parent
                source: root.image
                // source: root.getUrgency()
                fillMode: Image.PreserveAspectCrop
                smooth: true
            }
            Text {
                text: ""
                font.pixelSize: 26
                anchors.centerIn: parent
                Layout.fillWidth: true
                color: Config.colors.fontcolor
                visible: root.image === ""
            }
        }
        ColumnLayout {
            Text {
                text: root.title
                font.bold: true
                font.pixelSize: 18
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                color: Config.colors.fontcolor
                font.family: Config.font
            }
            Text {
                text: root.body.length > 123 ? root.body.substr(0, 120) + "..." : root.body
                visible: root.body.length > 0
                font.pixelSize: 12
                color: Config.colors.fontcolor
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.family: Config.font
            }
            RowLayout {
                visible: root.buttons.length > 1
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                spacing: 20

                Repeater {
                    model: root.buttons
                    anchors.margins: 10
                    StyledButton {
                        implicitHeight: 30
                        text: modelData.label
                        onClicked: modelData.onClick()
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseHandler

        anchors.fill: parent
        hoverEnabled: true
        visible: root.buttons.length === 0 || root.buttons.length === 1
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.buttons.length === 1 && root.buttons[0].onClick) {
                root.buttons[0].onClick();
                root.rawNotif?.notificatio.dismiss();
            } else if (root.buttons.length === 0) {
                console.log("[Notification] Dismissed a notification with no action.");
                root.rawNotif.notification.tracked = false;
                root.rawNotif.popup = false;
                root.rawNotif?.notification.dismiss();
            } else {
                console.log("[Notification] Dismissed a notification with multiple actions.");
                root.rawNotif?.notification.dismiss();
            }
        }
    }
    Component.onCompleted: {
        startAnim = true;
    }
}
