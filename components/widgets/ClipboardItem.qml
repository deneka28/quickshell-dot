import QtQuick
import Qt.labs.qmlmodels
import QtQml

import "../io"


Item {
    id: root
    property list<var> items
    property list<string> cliphistData: ClipboardIo.clipHistList
    implicitHeight: parent.height
    implicitWidth: parent.width
    visible: true
    Rectangle {
        id: rootrect 
        color: "transparent"
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        radius: 5
        clip: true

        TableView {
            id: table 
            clip: true
            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10
            columnSpacing: 0
            resizableColumns: true
            columnWidthProvider: column => {
                if (column === 0) {
                    return 60;
                }
                return width - 60;
            }
            rowSpacing: 1 
            property list<var> clipboardEntries: {
                let map = root.items.map(item => item.split(" "));
                let obj = map.map(item => {
                    return {
                        entryId: item[0],
                        entryData: item[1]
                    };
                });
                return obj;
            }
            model: TableModel {
                TableModelColumn {
                    display: "entryId"
                }
                TableModelColumn {
                    display: "entryData"
                }
                rows: [...table.clipboardEntries]
            }
            delegate: Rectangle {
                clip: true
                required property string display
                required property bool current
                required property bool selected
                border.width: current ? 1 : 0
                implicitWidth: table.width
                implicitHeight: 30
                color: "blue"
                Text {
                    color: "#fafafa"
                    text: parent.display
                }
                MouseArea {
                    id: dataEntryMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    property var hoveredItem
                    onEntered: {
                        if (!isNaN(parent.display)) {
                            console.log(parent.display);
                            ClipboardIo.decodedId = parent.display;
                            ClipboardIo.runningDecode = true;
                        }
                    }
                    onExited: {
                        ClipboardIo.decodedId = "";
                        ClipboardIo.runningDecode = false
                    }
                    Connections {
                        enabled: true
                        target: ClipboardIo
                        function onDecoded(decoded) {
                            dataEntryMouseArea.hoveredItem = decoded;
                        }
                    }
                }

            }
        }
     }
}
