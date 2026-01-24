pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Qt.labs.qmlmodels
import QtQml
import Quickshell

import "../io"
import "../shared"

Item {
    id: root
    property list<var> items: ClipboardIo.clipHistList
    //property list<string> cliphistData: ClipboardIo.clipHistList
    implicitHeight: parent.height
    implicitWidth: parent.width
    visible: true
    function refresh() {
        ClipboardIo.clipHistList = []
        ClipboardIo.runningList = true
    }

    Component.onCompleted: refresh()
    
    Rectangle {
        id: rootrect 
        color: "transparent"
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        radius: 5
        clip: true 

        Rectangle {
            id: searchBar
            width: parent.width - 10
            height: 40
            anchors.top: rootrect.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#313244"
            radius: 5
            border.width: searchInput.activeFocus ? 1 : 0
            border.color: "#89b4fa"

            TextField {
                id: searchInput
                anchors.fill: parent 
                anchors.margins: 5
                placeholderText: "Поиск..."
                color: "#cdd6f4"
                font.pixelSize: 14
                background: Rectangle {
                    color: "transparent"
                }
                Component.onCompleted: forceActiveFocus()
            }
        }
                // Сообщение если список пуст
        Text {
            visible: table.clipboardEntries.length === 0 && searchInput.text === ""
            anchors.centerIn: parent
            text: "История буфера обмена пуста"
            color: "#cdd6f4"
            font.pixelSize: 14
        }

        Text {
            visible: table.clipboardEntries.length === 0 && searchInput.text !== ""
            anchors.centerIn: parent
            text: "Ничего не найдено"
            color: "#cdd6f4"
            font.pixelSize: 14

        }

        TableView {
            id: table 
            visible: clipboardEntries.length > 0
            clip: true
            anchors.top: searchBar.bottom
            anchors.topMargin: 10 
            anchors.bottom: rootrect.bottom
            anchors.bottomMargin: 10 
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10 - searchBar.height - 60
            columnSpacing: 0
            rowSpacing: 1

            function getContentType(data) {
                if (data.startsWith("file://") && 
                (data.match(/\.(jpg|jpeg|png|gif|bmp|webp|svg)$/i))) {
                    return "image-file"
                }

                if (data.includes("gimp") ||
                    data.includes("PNG") ||
                    data.includes("JFIF") ||
                    data.match(/[^\x20-\x7E]{10,}/)) {
                        return "image-binary"
                }
                if (data.startsWith("file://")) {
                    return "file"
                }
                return "text"
            }

            function getDisplayText(data, type) {
                if (type === "image-file") {
                    let filename = data.split('/').pop()
                    return `🖼️ ${filename}`
                }
                if (type === "file") {
                    let filename = data.replace("file://", "").split('/').pop()
                    return `📄 ${filename}`
                }
                return data.length > 100 ? data.substring(0, 100) + "..." : data
            }

            property list<var> clipboardEntries: {
                let entries = []
                let searchText = searchInput.text.toLowerCase()

                for (let i = 0; i < root.items.length; i++) {
                    let line = root.items[i]
                    if (!line || line.trim() === "") continue
                    
                    let tabIndex = line.indexOf('\t')
                    if (tabIndex > 0) {
                        let id = line.substring(0, tabIndex).trim()
                        let data = line.substring(tabIndex + 1).trim()

                        let contentType = table.getContentType(data)
                        let displayText = table.getDisplayText(data, contentType)

                        if (searchText !== "" && 
                            !displayText.toLowerCase().includes(searchText) &&
                            !data.toLowerCase().includes(searchText)) {
                            continue
                        }

                        let displayData = data
                        if (data.length > 100) {
                            displayData = data.substring(0, 100) + "..."
                        }

                        let imagePath = ""
                        if (contentType === "image-file") {
                            imagePath = decodeURIComponent(data.replace("file://", ""))
                        }

                        entries.push({
                            entryId: id, 
                            entryData: displayData,
                            fullData: data,
                            contentType: contentType,
                            imagePath: imagePath
                        })
                    }
                }
                return entries 
            }

            columnWidthProvider: function(column) {
                if (column === 0) {
                    return table.width
                }
                return table.width - columnSpacing
            }

            model: TableModel {
                // TableModelColumn { display: "entryId" }
                TableModelColumn { display: "entryData" }
                rows: [...table.clipboardEntries]
            }
            delegate: Rectangle {
                clip: true
                required property string display
                required property bool current
                required property bool selected
                required property int row 
                required property int column

                readonly property var currentEntry: (row < table.clipboardEntries.length) ? table.clipboardEntries[row] : null

                implicitHeight: {
                    let entry = table.clipboardEntries[row]

                    return (entry && entry.contentType === "image-file" && column === 0) ? 120 : 35
                }

                color: dataEntryMouseArea.containsMouse ? "#45475a" : "transparent"
                StyledButton {
                    id: deleteItem
                    visible: column === 0 && currentEntry !== null
                    iconSize: 20
                    iconSource: Quickshell.iconPath("edit-delete")
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        let originalLine = root.items[row]
                        if (originalLine) {
                            ClipboardIo.deleteEntry(originalLine)
                        }
                    }
                    z: 2
                }
                Image {
                    visible: {
                        if (row >= table.clipboardEntries.length) return false
                        let entry = table.clipboardEntries[row]
                        return entry && entry.contentType === "image-file" && column === 0
                    }
                    anchors.fill: parent
                    anchors.margins: 5
                    readonly property var entry: table.clipboardEntries[row]
                    source: (entry && entry.imagePath) ? entry.imagePath : ""
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: false

                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.log("Error loading image: ", source)
                        } else if (status === Image.Ready) {
                            console.log("Image loaded successfully: ", source)
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "#313244"
                        border.width: 1 
                        radius: 3 
                    }
                }
                
                Text {
                    visible: {
                        if (row >= table.clipboardEntries.length) return true
                        let entry = table.clipboardEntries[row]
                        return !(entry && entry.contentType === "image-file" && column === 0)
                    }
                    anchors.fill: parent
                    anchors.margins: 5
                    color: "#cdd6f4"
                    text: display
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: column === 1 ? Text.AlignHCenter : Text.AlignLeft
                    font.pixelSize: parent.column === 0 ? 10 : 12 
                    font.family: "monospace"
                }

                MouseArea {
                    id: dataEntryMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        let entry = table.clipboardEntries[row]
                        if (entry && entry.entryId) {
                            console.log("Copying: ", entry.entryId, "type: ", entry.contentType)
                            console.log("Image path: ", entry.imagePath)
                            ClipboardIo.copyEntry(entry.entryId, entry.contentType || "text")
                        } else {
                            console.log("No entry found for row:", row)
                        }
                    }
                }
            }
        }
     }
}
