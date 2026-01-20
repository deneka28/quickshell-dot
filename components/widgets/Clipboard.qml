import Quickshell
import QtQuick
import QtQml
import Qt.labs.qmlmodels

import "root:/"
import "../io"
import "../widgets"
import "../shared"


SlidingPopup {
    id: clipboardPopup
    
    direction: "down"
    anchor {
        item: root
        margins.top: 34
        edges: Edges.Top
        gravity: Edges.Bottom
    }

    implicitWidth: 400
    implicitHeight: 400
    visible: open
    property bool open: false
    color: "transparent"
    cornerRadius: 5 

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
            items: ClipboardButton.cliphistData
        }
    }
}
