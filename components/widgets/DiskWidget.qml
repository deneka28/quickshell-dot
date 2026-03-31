import "../services"
import "../shared"
import QtQuick
import Quickshell
import Quickshell.Widgets
import "root:/"

Rectangle {
    id: root

    property string useHome: info.storHomeUsed
    property string useRoot: info.storRootUsed
    property string freeRoot: info.storRootFree
    property string freeHome: info.storHomeFree
    property int totalHome: info.storHomeFree + info.storHomeUsed
    property int totalRoot: info.storRootFree + info.storRootUsed

    implicitWidth: 165
    implicitHeight: 200
    radius: 6
    color: "#454545"

    CircleBat {
        id: home

        size: 150
        colorCircle: "#3058f3"
        colorBackground: Config.colors.bgcolor
        showBackground: false
        arcBegin: 0
        arcOffset: 220
        arcEnd: (280 / root.totalHome) * info.storHomeUsed
        lineWidth: 8
        anchors.centerIn: parent

        Text {
            id: spaceHome

            text: root.useHome + "/" + root.totalHome
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.family: Config.family
            font.pixelSize: 14
            color: Config.colors.fontcolor
        }

        IconImage {
            id: icon

            implicitWidth: 64
            implicitHeight: 64
            anchors.centerIn: parent
            source: Quickshell.iconPath("am-harddisk-symbolic")
        }

    }

    CircleBat {
        id: rootSpace

        size: 125
        colorCircle: "#f33058"
        colorBackground: Config.colors.bgcolor
        showBackground: false
        arcBegin: 0
        arcOffset: 220
        arcEnd: (280 / root.totalRoot) * info.storRootUsed
        lineWidth: 8
        anchors.centerIn: parent

        Text {
            id: spaceRoot

            text: root.useRoot + "/" + root.totalRoot
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.family: Config.family
            font.pixelSize: 14
            color: Config.colors.fontcolor
        }

    }

    DiskInfo {
        id: info
    }

}
