import "../io"
import "../shared"
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "root:/"

CircleBat {
    id: root

    size: 90
    colorCircle: Config.colors.fontcolor
    colorBackground: Config.colors.bgcolor
    showBackground: false
    arcBegin: 0
    arcOffset: 220
    arcEnd: 280 * pipew.node.audio.volume
    lineWidth: 4

    PipewireIO {
        id: pipew

        node: Pipewire.defaultAudioSink
    }

    IconImage {
        // anchors.bottomMargin: 6

        id: icon

        implicitHeight: 36
        implicitWidth: 36
        anchors.centerIn: parent
        source: Quickshell.iconPath("audio-volume-high-symbolic")
    }

    Text {
        id: brigPercent

        text: Math.round(pipew.node.audio.volume * 100) + "%"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        font.family: Config.family
        font.pixelSize: 16
        color: Config.colors.fontcolor
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        scrollGestureEnabled: true
        onWheel: (event) => {
            event.accepted = true;
            pipew.node.audio.volume += (event.angleDelta.y / 120) * 0.05;
        }
    }

}
