pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "root:/"
import "../shared"
import "../services"

PopupPanel {
    id: slidingPopup

    direction: "down" // left, right, up, down
    anchors {
        top: true
        left: false
        right: true
    }
    margins {
        top: 4
        right: 4
    }
    implicitWidth: 400
    implicitHeight: 400
    visible: open
    property bool open: false
    color: "transparent"
    cornerRadius: 5

    contentItem: Rectangle {
        anchors.centerIn: parent
        color: Config.colors.widgetcolor
        implicitHeight: slidingPopup.implicitHeight - 4
        implicitWidth: slidingPopup.implicitWidth - 4
        radius: 8
        border.width: 1
        border.color: '#0cc0f2'

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent

            RowLayout {
                id: info
                Layout.fillWidth: true

                Rectangle {
                    id: profPic
                    Layout.leftMargin: 10
                    implicitHeight: 100
                    implicitWidth: 100
                    border.width: 1
                    color: "transparent"
                    radius: 8
                    border.color: Config.colors.fontcolor
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: profPic.width
                            height: profPic.height
                            radius: profPic.radius
                        }
                    }
                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        cache: true
                        opacity: 0.9
                        source: "../../assets/icon.jpg"
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 4

                    Text {
                        text: SystemDetails.username
                        font.family: Config.family
                        font.pixelSize: 24
                        color: Config.colors.fontcolor
                    }

                    RowLayout {
                        spacing: 10

                        Text {
                            text: SystemDetails.osIcon
                            font.family: Config.family
                            font.pixelSize: 24
                            color: Config.colors.fontcolor
                        }
                        Text {
                            text: Stringify.shortText(SystemDetails.uptime, 18)
                            font.family: Config.family
                            font.pixelSize: 18
                            color: Config.colors.fontcolor
                        }
                    }
                }
            }

            Rectangle {
                id: spaser

                implicitHeight: 2
                implicitWidth: parent.width - 30
                Layout.alignment: Qt.AlignHCenter
                color: '#414141'
            }
            RowLayout {

                ColumnLayout {
                    id: sysInfo
                    spacing: 5
                RowLayout {
                    id: bright
                    Layout.fillWidth: true

                    BrightnessWidget {
                        id: brightness
                        Layout.topMargin: 10
                        Layout.leftMargin: 10
                    }
                    VolumeWidget {
                        id: vol
                        Layout.topMargin: 10
                        Layout.leftMargin: 10
                    }

                }
                RowLayout {
                    Layout.fillWidth: true

                    CpuWidget {
                        id: cpu 
                        Layout.topMargin: 10 
                        Layout.leftMargin: 10 
                    }
                    MemWidget {
                        id: mem 
                        Layout.topMargin: 10 
                        Layout.leftMargin: 10 
                    }
                }
            }
            DiskWidget {
                id: disk 
                Layout.topMargin: 10 
                Layout.leftMargin: 10 
                // Layout.rightMargin: 10 
            }
            }

        }
    }
}
