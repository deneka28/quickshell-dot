import QtQuick

import "../io"


Rectangle {
    id: root
    
    property int tooltipText: ClipboardIo.clipHistCount
    property list<string> cliphistData: ClipboardIo.clipHistList
    property bool showPopup: false
    anchors.centerIn: parent
    color: "transparent"
    border.width: 2
    property color mainColor: mouseArea.isHovered ? Qt.lighter("red", 1.6) : Qt.lighter("red", 1.3)
    border.color: mainColor
    implicitWidth: 42
    implicitHeight: 35
    radius: 30
    


    MouseArea {
        id: mouseArea 
        anchors.fill: parent
        property bool isHovered: false
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                if (root.cliphistData.length === 0 || (ClipboardIo.runningList && ClipboardIo.clipHistCount !== root.tooltipText)) {
                    ClipboardIo.runningList = true
                }
                root.showPopup =! root.showPopup
            } else if (mouse.button === Qt.RightButton) {
                ClipboardIo.runningWipe = true
            }
        }
        onEntered: {
            ClipboardIo.runningCount = true
            isHovered = true
        }
        onExited: {
            isHovered = false
        }
    }
}
