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
    arcEnd: 360 * pipew.node.audio.volume
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
        source: Quickshell.iconPath("audio-volume-high-symbolic")
    }

    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            event.accepted = true;
            pipew.node.audio.volume += (event.angleDelta.y / 120) * 0.05;
        }
        onClicked: {
            grab.active = true;
            volumeDock.show();
        }
    }
    VolumeDock {
        id: volumeDock
    }
}
