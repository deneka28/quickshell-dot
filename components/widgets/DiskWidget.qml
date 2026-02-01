import "../services"
import "../shared"
import QtQuick
import QtQuick.Layouts
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

    RowLayout {
        spacing: 1
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            id: diskL

            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 2

            CustomProgress {
                id: useHomeProg

                progHeight: 158
                progWidth: 6
                progRadius: 10
                bgColor: Config.colors.controlscolor
                fgColor: Config.colors.mainColor2
                fgWidth: progWidth
                value: (useHomeProg.height / root.totalHome) * info.storHomeUsed
                anchors.bottom: useHome.top
                Layout.leftMargin: (root.width / 2) / 2
                Layout.topMargin: 10
            }

            Text {
                id: useHome

                text: "/home: " + root.useHome + "/" + root.freeHome + "G"
                font.family: Config.family
                font.pixelSize: 10
                color: Config.colors.fontcolor
                topPadding: 5
                leftPadding: 5
            }

        }

        ColumnLayout {
            id: disk

            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 2

            CustomProgress {
                id: useRootProg

                progHeight: 158
                progWidth: 6
                progRadius: 10
                bgColor: Config.colors.controlscolor
                fgColor: Config.colors.mainColor2
                fgWidth: progWidth
                value: (useRootProg.height / root.totalRoot) * info.storRootUsed
                anchors.bottom: useHome.top
                Layout.leftMargin: (root.width / 2) / 2 - this.width
                Layout.topMargin: 10
            }

            Text {
                id: useRoot

                width: root.width / 2
                text: "/: " + root.useRoot + "/" + root.freeRoot + "G"
                font.family: Config.family
                font.pixelSize: 10
                color: Config.colors.fontcolor
                topPadding: 5
                leftPadding: 5
            }

        }

    }

    DiskInfo {
        id: info
    }

}
