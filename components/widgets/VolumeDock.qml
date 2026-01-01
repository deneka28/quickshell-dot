import QtQuick
import Quickshell.Services.Pipewire
import QtQuick.Controls
import QtQuick.Layouts

import "root:/"
import "../shared"
import "../window"

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
    implicitHeight: 260
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

        ScrollView {
            anchors.fill: parent
            contentWidth: availableWidth

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                // get a list of nodes that output to the default sink
                PwNodeLinkTracker {
                    id: linkTracker
                    node: Pipewire.defaultAudioSink
                }

                VolumeMixer {
                    node: Pipewire.defaultAudioSink
                }

                Rectangle {
                    Layout.fillWidth: true
                    color: palette.active.text
                    implicitHeight: 1
                }

                Repeater {
                    model: linkTracker.linkGroups

                    VolumeMixer {
                        required property PwLinkGroup modelData
                        // Each link group contains a source and a target.
                        // Since the target is the default sink, we want the source.
                        node: modelData.source
                    }
                }
            }
        }
    }
}