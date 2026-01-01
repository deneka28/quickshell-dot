import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import "root:/"
import "../shared"
import "../io"

CircleBat {
    id: root
    size: 90
    colorCircle: Config.colors.fontcolor
    colorBackground: Config.colors.bgcolor
    showBackground: true
    arcBegin: 0
    arcEnd: 360 * pipew.node.audio.volume
    lineWidth: 9

    PipewireIO {
        id: pipew
        node: Pipewire.defaultAudioSink
    }

    Rectangle {
        id: separator
        implicitHeight: 2
        implicitWidth: root.size - 30
        anchors.centerIn: parent
    }

    IconImage {
        id: icon
        implicitHeight: 24
        implicitWidth: 24
        anchors.horizontalCenter: parent.horizontalCenter
        source: Quickshell.iconPath("audio-volume-high-symbolic")
        anchors.bottomMargin: 6
        anchors.bottom: separator.top
    }
    Text {
        id: brigPercent
        text: Math.round(pipew.node.audio.volume * 100) + "%"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: 6
        font.family: Config.family
        font.pixelSize: 16
        color: Config.colors.fontcolor
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        scrollGestureEnabled: true
        onWheel: event => {
            event.accepted = true;
            pipew.node.audio.volume += (event.angleDelta.y / 120) * 0.05;
        }
    }
}