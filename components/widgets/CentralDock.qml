pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import Quickshell.Hyprland


import "root:/"
import "../shared"
import "../calendar"
import "../widgets"
import "../notifications"

SlidingPopup {
    id: centralPopup

    direction: "down" // left, right, up, down
    anchor {
        item: root
        margins.top: 37
        edges: Edges.Top
        gravity: Edges.Bottom
    }
    
    implicitWidth: 700
    implicitHeight: 400
    visible: open
    property bool open: false
    color: "transparent"
    cornerRadius: 5

    contentItem: Rectangle {
        anchors.centerIn: parent
        anchors.fill: parent
        color: Config.colors.widgetcolor
        implicitHeight: datePicker.implicitHeight - 4
        implicitWidth: datePicker.implicitWidth - 4
        radius: 8
        border.width: 1
        border.color: '#0cc0f2'

        Row {
            anchors.fill: parent
            spacing: 15
            Rectangle {
                id: blue
                color: "transparent"
                //border.width: 1
                implicitWidth: parent.width / 2
                implicitHeight: parent.height

                NotifList {

                }

            }
            Rectangle {
                id: spaser
                color: "#2196F3"
                //border.width: 1
                implicitWidth: 1
                implicitHeight: parent.height - 30
                anchors.verticalCenter: parent.verticalCenter
            }
            DatePicker {
                id: datePicker
            }
        }
    }
}
