pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    property bool sinkMuted: Pipewire.defaultAudioSink.audio.muted
    property real sinkVolume: Pipewire.defaultAudioSink.audio.volume
    property string sinkIcon: {
        const volume = Math.round(sinkVolume * 100) / 100;
        if (sinkMuted) {
            return "fa_volume_xmark.svg";
        }
        if (volume >= 0.7) {
            return Quickshell.iconPath("audio-volume-high-symbolic");
        }
        if (volume >= 0.3) {
            return Quickshell.iconPath("audio-volume-low-symbolic");
        }
        return Quickshell.iconPath("audio-volume-muted-symbolic");
    }

    function toggleSinkMute() {
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_SINK@", "toggle"]);
    }

    function setSinkVolume(volume: real) {
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_SINK@", volume]);
    }

    property bool sourceMuted: Pipewire.defaultAudioSource.audio.muted
    property real sourceVolume: Pipewire.defaultAudioSource.audio.volume
    property string sourceIcon: {
        if (sourceMuted) {
            return "fa_microphone_lines_slash.svg";
        }
        return "fa_microphone_lines.svg";
    }

    function toggleSourceMute() {
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_SOURCE@", "toggle"]);
    }

    function setSourceVolume(volume: real) {
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_SOURCE@", volume]);
    }
}