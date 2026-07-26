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
    arcEnd: 280 * Math.min(1, pipew.node.audio.volume)
    lineWidth: 4

    PipewireIO {
        id: pipew

        node: Pipewire.defaultAudioSink
    }

    IconImage {
        id: icon

        implicitHeight: 36
        implicitWidth: 36
        anchors.centerIn: parent
        source: {
            const v = pipew.node.audio.volume;
            if (pipew.node.audio.muted)
                return Quickshell.iconPath("audio-volume-muted-symbolic");
            if (v >= 0.66)
                return Quickshell.iconPath("audio-volume-high-symbolic");
            if (v >= 0.33)
                return Quickshell.iconPath("audio-volume-medium-symbolic");
            return Quickshell.iconPath("audio-volume-low-symbolic");
        }
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
        onClicked: pipew.node.audio.muted = !pipew.node.audio.muted
        onWheel: event => {
            event.accepted = true;
            const delta = (event.angleDelta.y / 120) * 0.05;
            // pipew.node.audio.volume += (event.angleDelta.y / 120) * 0.05;
            pipew.node.audio.volume = Math.max(0, Math.min(1, pipew.node.audio.volume + delta));
        }
    }
}
