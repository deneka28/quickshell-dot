pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io 

Singleton {
    id: root
    
    property string decodedId
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
        onExited: root.runningWipe = false
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
        command: ["sh", "-c", `cliphist decode ${root.decodedId}`]
        stdout: SplitParser {
            onRead: data => {
                root.decoded(data)
            }
        }
        onExited: root.runningDecode = false
    }
    Process {
        id: clipHistCopy
        running: root.runningCopy
        command: ["sh", "-c", `wl-copy ${root.copyItem}`]
        onExited: root.runningDecode = false
    }

}





