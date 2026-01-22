pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io 

Singleton {
    id: root
    
    property string decodedId
    property string contentType: "text"
    property bool runningDecode: false
    property var copyItem
    property bool runningCopy
    property bool runningList: false
    property bool runningWipe: false
    property bool runningCount: true
    property int clipHistCount: 0
    property list<string> clipHistList: []

    signal decoded(var data)
    signal copy

    function refreshList() {
        clipHistList = []
        runningList = true
    }

    Process {
        id: clipHist 
        running: root.runningList
        command: ["sh", "-c", "cliphist list"]
        stdout: SplitParser {
            onRead: data => {
                root.clipHistList.push(data)
            }
        }
        onExited: root.runningList = false
    }
    Process {
        id: clipHistWipe
        running: root.runningCount
        command: ["sh", "-c", "cliphist wipe"]
        onExited: {
            root.runningWipe = false
            root.clipHistList = []
            root.clipHistCount = 0
        }
    }
    Process {
        id: clipHistCount
        running: root.runningCount
        command: ["sh", "-c", "cliphist list | wc -l"]
        stdout: SplitParser {
            onRead: data => {
                root.clipHistCount = data
                if (Number(data) >= 500) {
                    root.runningWipe = false
                }
            }
        }
        onExited: (code, status) => {
            root.runningCount = false
        }
    }
Process {
    id: clipHistDecode
    running: root.runningDecode
    command: ["sh", "-c", `echo -n '${root.decodedId}' | cliphist decode | tr -d '\r\n'`]
    // Добавили tr -d '\r\n' чтобы убрать переносы строк
    
    stdout: SplitParser {
        onRead: data => {
            root.decoded(data)
        }
    }
    onExited: root.runningDecode = false
}
Process {
        id: clipHistCopyImage
        running: false
        command: []

        stderr: SplitParser {
            onRead: data => {
                console.log("Image copy stderr:", data)
            }
        }

        onExited: (code, status) => {
            console.log("Image copy process exited with code:", code, "status:", status)
            root.runningCopy = false
        }
    }
    Process {
        id: clipHistCopy
        running: root.runningCopy && root.contentType === "text"
        command: ["sh", "-c", `echo -n '${root.decodedId}' | cliphist decode | wl-copy`]
        
        stdout: SplitParser {
            onRead: data => {
                console.log("Copy stdout:", data)
            }
        }
    
        stderr: SplitParser {
            onRead: data => {
                console.log("Copy stderr:", data)
            }
        }
    
        onStarted: {
            console.log("Copy process started with ID:", root.decodedId)
        }
        onExited: (code, status) => {
            console.log("Copy process exited with code:", code, "status:", status)
            if (code === 0) {
                console.log("Successfuly copied to clipboard!")
            }
            root.runningCopy = false
        }    
    }

    function copyEntry(entryId, type) {
    decodedId = entryId
    contentType = type
    
    if (type === "image-file") {
        // Сначала декодируем путь, потом копируем
        clipHistDecode.command = ["sh", "-c", `echo -n '${entryId}' | cliphist decode`]
        runningDecode = true
    } else if (type === "image-binary") {
        clipHistCopyImage.command = ["bash", "-c",
            `echo -n '${entryId}' | cliphist decode | wl-copy`
        ]
        console.log("Copying binary image")
        clipHistCopyImage.running = true
    } else {
        runningCopy = true
    }
}

Connections {
    target: root
    enabled: root.contentType === "image-file"
    function onDecoded(data) {
        // Убираем ВСЕ непечатаемые символы
        let cleanData = data.replace(/[\r\n\t]/g, '').trim()
        let path = cleanData.replace("file://", "")
        let decodedPath = decodeURIComponent(path)
        
        console.log("Original path:", JSON.stringify(data))  // Покажет все спецсимволы
        console.log("Clean path:", JSON.stringify(cleanData))
        console.log("Decoded path:", decodedPath)
        
        // Копируем файл
        clipHistCopyImage.command = ["bash", "-c", 
            `cat "${decodedPath}" | wl-copy`
        ]
        clipHistCopyImage.running = true
    }
}
}





