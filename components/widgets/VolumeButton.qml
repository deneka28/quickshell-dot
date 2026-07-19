import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

import "root:/"
import "../shared"
import "../io"

CircleBat {
    id: root
    size: 30
    colorCircle: Config.colors.fontcolor
    colorBackground: Config.colors.bgcolor
    showBackground: true
    arcBegin: 0
    // arcEnd: 360 * pipew.node.audio.volume
    arcEnd: 360 * Math.min(1, pipew.node.audio.volume)
    lineWidth: 2

    HyprlandFocusGrab {
        id: grab
        windows: [volumeDock]
        onCleared: {
            volumeDock.closeWithAnimation();
        }
    }

    PipewireIO {
        id: pipew
        node: Pipewire.defaultAudioSink
    }

    IconImage {
        id: icon
        implicitHeight: 16
        implicitWidth: 16
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

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onWheel: event => {
            event.accepted = true;
            const delta = (event.angleDelta.y / 120) * 0.05;
            pipew.node.audio.volume = Math.max(0, Math.min(1, pipew.node.audio.volume + delta));
        }

        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton) {
                pipew.node.audio.muted = !pipew.node.audio.muted;
            }
            if (mouse.button === Qt.LeftButton) {
                grab.active = true;
                volumeDock.show();
            }
        }
    }
    VolumeDock {
        id: volumeDock
    }
}
