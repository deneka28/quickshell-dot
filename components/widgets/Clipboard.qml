import "../io"
import "../shared"
import "../widgets"
import QtQml
import QtQuick
import Quickshell
import "root:/"

SlidingPopup {
    id: clipboardPopup

    property bool open: false

    direction: "down"
    implicitWidth: 400
    implicitHeight: 400
    visible: open
    color: "transparent"
    cornerRadius: 5

    anchor {
        item: root
        margins.top: 34
        edges: Edges.Top
        gravity: Edges.Bottom
    }

    contentItem: Rectangle {
        anchors.centerIn: parent
        anchors.fill: parent
        color: Config.colors.widgetcolor
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 8
        border.width: 1
        border.color: "#0cc0f2"

        ClipboardItem {
            items: ClipboardIo.clipHistList
        }

    }

}
